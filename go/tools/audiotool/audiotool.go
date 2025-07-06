package audiotool

import (
	"fmt"
	"io"
	"os"
	"path/filepath"

	"github.com/go-audio/audio"
	"github.com/go-audio/wav"
	"github.com/hajimehoshi/go-mp3"
)

// AudioMixer 音频混合器
type AudioMixer struct {
	BitDepth         int
	TargetSampleRate int
	TargetNumChans   int
}

// NewAudioMixer 创建新的音频混合器
func NewAudioMixer() *AudioMixer {
	return &AudioMixer{
		BitDepth:         16,
		TargetSampleRate: 44100,
		TargetNumChans:   2,
	}
}

// MixAndSpliceAudio 同时混合和拼接音频
func (am *AudioMixer) MixAndSpliceAudio(mainAudioFile, backgroundAudioFile, outputFile string, mainVolume, backgroundVolume, prefixSec, suffixSec float64) error {
	mainData, err := am.decodeAudioToSamples(mainAudioFile)
	if err != nil {
		return fmt.Errorf("failed to decode main file: %w", err)
	}
	backgroundData, err := am.decodeAudioToSamples(backgroundAudioFile)
	if err != nil {
		return fmt.Errorf("failed to decode background file: %w", err)
	}

	fmt.Println("Step 1: Mixing main audio with background music...")
	mixedMainData := am.mixSamples(mainData, backgroundData, mainVolume, backgroundVolume)

	fmt.Println("Step 2: Extracting prefix and suffix from background music...")
	prefixSampleCount := int(prefixSec * float64(am.TargetSampleRate) * float64(am.TargetNumChans))
	suffixSampleCount := int(suffixSec * float64(am.TargetSampleRate) * float64(am.TargetNumChans))

	var prefixSamples []int
	if prefixSampleCount > 0 && len(backgroundData) > 0 {
		end := prefixSampleCount
		if end > len(backgroundData) {
			end = len(backgroundData)
		}
		prefixSamples = backgroundData[:end]
	}

	var suffixSamples []int
	if suffixSampleCount > 0 && len(backgroundData) > 0 {
		start := len(backgroundData) - suffixSampleCount
		if start < 0 {
			start = 0
		}
		suffixSamples = backgroundData[start:]
	}

	fmt.Println("Step 3: Splicing all parts together...")
	finalCapacity := len(prefixSamples) + len(mixedMainData) + len(suffixSamples)
	finalData := make([]int, 0, finalCapacity)
	finalData = append(finalData, prefixSamples...)
	finalData = append(finalData, mixedMainData...)
	finalData = append(finalData, suffixSamples...)

	prefixDuration := float64(len(prefixSamples)) / float64(am.TargetSampleRate) / float64(am.TargetNumChans)
	mainDuration := float64(len(mixedMainData)) / float64(am.TargetSampleRate) / float64(am.TargetNumChans)
	suffixDuration := float64(len(suffixSamples)) / float64(am.TargetSampleRate) / float64(am.TargetNumChans)

	fmt.Printf("Final audio: %.2fs prefix + %.2fs mixed main + %.2fs suffix = %.2fs total\n",
		prefixDuration, mainDuration, suffixDuration, prefixDuration+mainDuration+suffixDuration)

	return am.saveToFile(finalData, outputFile)
}

// SpliceAudioFiles 拼接两个音频文件
func (am *AudioMixer) SpliceAudioFiles(mainAudioFile, backgroundAudioFile, outputFile string, prefixSec, suffixSec float64) error {
	mainData, err := am.decodeAudioToSamples(mainAudioFile)
	if err != nil {
		return fmt.Errorf("failed to decode main file: %w", err)
	}
	backgroundData, err := am.decodeAudioToSamples(backgroundAudioFile)
	if err != nil {
		return fmt.Errorf("failed to decode background file: %w", err)
	}

	prefixSampleCount := int(prefixSec * float64(am.TargetSampleRate) * float64(am.TargetNumChans))
	suffixSampleCount := int(suffixSec * float64(am.TargetSampleRate) * float64(am.TargetNumChans))

	var prefixSamples []int
	if prefixSampleCount > 0 && len(backgroundData) > 0 {
		end := prefixSampleCount
		if end > len(backgroundData) {
			end = len(backgroundData)
		}
		prefixSamples = backgroundData[:end]
	}

	var suffixSamples []int
	if suffixSampleCount > 0 && len(backgroundData) > 0 {
		start := len(backgroundData) - suffixSampleCount
		if start < 0 {
			start = 0
		}
		suffixSamples = backgroundData[start:]
	}

	finalCapacity := len(prefixSamples) + len(mainData) + len(suffixSamples)
	splicedData := make([]int, 0, finalCapacity)
	splicedData = append(splicedData, prefixSamples...)
	splicedData = append(splicedData, mainData...)
	splicedData = append(splicedData, suffixSamples...)

	prefixDuration := float64(len(prefixSamples)) / float64(am.TargetSampleRate) / float64(am.TargetNumChans)
	mainDuration := float64(len(mainData)) / float64(am.TargetSampleRate) / float64(am.TargetNumChans)
	suffixDuration := float64(len(suffixSamples)) / float64(am.TargetSampleRate) / float64(am.TargetNumChans)

	fmt.Printf("Splicing audio: %.2fs prefix + %.2fs main + %.2fs suffix = %.2fs total\n",
		prefixDuration, mainDuration, suffixDuration, prefixDuration+mainDuration+suffixDuration)

	return am.saveToFile(splicedData, outputFile)
}

// MixAudioFiles 混合两个音频文件
func (am *AudioMixer) MixAudioFiles(originalFile, backgroundFile, outputFile string, originalVolume, backgroundVolume float64) error {
	originalData, err := am.decodeAudioToSamples(originalFile)
	if err != nil {
		return fmt.Errorf("failed to decode original file: %w", err)
	}
	backgroundData, err := am.decodeAudioToSamples(backgroundFile)
	if err != nil {
		return fmt.Errorf("failed to decode background file: %w", err)
	}
	mixedData := am.mixSamples(originalData, backgroundData, originalVolume, backgroundVolume)
	return am.saveToFile(mixedData, outputFile)
}

// private methods

func (am *AudioMixer) mixSamples(original, background []int, originalVolume, backgroundVolume float64) []int {
	finalLen := len(original)
	fmt.Printf("Mixing samples: final length will match original audio (%d samples)\n", finalLen)
	mixed := make([]int, finalLen)
	for i := 0; i < finalLen; i++ {
		originalSample := int(float64(original[i]) * originalVolume)
		var backgroundSample int
		if len(background) > 0 {
			backgroundSample = int(float64(background[i%len(background)]) * backgroundVolume)
		}
		mixedSample := originalSample + backgroundSample
		if mixedSample > 32767 {
			mixedSample = 32767
		} else if mixedSample < -32768 {
			mixedSample = -32768
		}
		mixed[i] = mixedSample
	}
	return mixed
}

func (am *AudioMixer) decodeAudioToSamples(filename string) ([]int, error) {
	format, err := am.detectFileFormat(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to detect file format: %w", err)
	}
	fmt.Printf("Detected format for %s: %s\n", filepath.Base(filename), format)
	switch format {
	case "mp3":
		return am.decodeMp3ToSamples(filename)
	case "wav":
		return am.decodeWavToSamples(filename)
	default:
		return nil, fmt.Errorf("unsupported format: %s", format)
	}
}

func (am *AudioMixer) detectFileFormat(filename string) (string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return "", err
	}
	defer file.Close()
	header := make([]byte, 12)
	n, err := file.Read(header)
	if err != nil || n < 12 {
		return "", fmt.Errorf("cannot read file header")
	}
	if string(header[0:4]) == "RIFF" && string(header[8:12]) == "WAVE" {
		return "wav", nil
	}
	if string(header[0:3]) == "ID3" || (header[0] == 0xFF && (header[1]&0xE0) == 0xE0) {
		return "mp3", nil
	}
	return "", fmt.Errorf("unsupported audio format")
}

func (am *AudioMixer) decodeMp3ToSamples(filename string) ([]int, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to open file %s: %w", filename, err)
	}
	defer file.Close()
	decoder, err := mp3.NewDecoder(file)
	if err != nil {
		return nil, fmt.Errorf("failed to create MP3 decoder: %w", err)
	}
	originalSampleRate := decoder.SampleRate()
	originalNumChans := 2
	fmt.Printf("MP3 Info - Original Sample Rate: %d Hz, Output Channels: %d\n", originalSampleRate, originalNumChans)
	samples := make([]int, 0)
	buf := make([]byte, 8192)
	for {
		n, err := decoder.Read(buf)
		if err != nil {
			if err == io.EOF {
				break
			}
			return nil, fmt.Errorf("failed to read MP3 data: %w", err)
		}
		limit := n
		if n%2 != 0 {
			limit = n - 1
		}
		for i := 0; i < limit; i += 2 {
			sample := int(int16(buf[i]) | int16(buf[i+1])<<8)
			samples = append(samples, sample)
		}
	}
	originalDuration := float64(len(samples)) / float64(originalSampleRate) / float64(originalNumChans)
	fmt.Printf("Original MP3: %d samples, %.2f seconds at %d Hz, %d channels\n",
		len(samples), originalDuration, originalSampleRate, originalNumChans)
	convertedSamples := am.convertToTargetFormat(samples, originalSampleRate, originalNumChans)
	return convertedSamples, nil
}

func (am *AudioMixer) decodeWavToSamples(filename string) ([]int, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to open file %s: %w", filename, err)
	}
	defer file.Close()
	decoder := wav.NewDecoder(file)
	if !decoder.IsValidFile() {
		return nil, fmt.Errorf("invalid WAV file")
	}
	originalSampleRate := int(decoder.SampleRate)
	originalNumChans := int(decoder.NumChans)
	fmt.Printf("WAV Info - Original Sample Rate: %d Hz, Channels: %d\n",
		originalSampleRate, originalNumChans)
	samples := make([]int, 0)
	fullBuf, err := decoder.FullPCMBuffer()
	if err != nil {
		return nil, fmt.Errorf("failed to read WAV data: %w", err)
	}
	intBuf := fullBuf.AsIntBuffer()
	samples = append(samples, intBuf.Data...)
	originalDuration := float64(len(samples)) / float64(originalSampleRate) / float64(originalNumChans)
	fmt.Printf("Original WAV: %d samples, %.2f seconds at %d Hz, %d channels\n",
		len(samples), originalDuration, originalSampleRate, originalNumChans)
	convertedSamples := am.convertToTargetFormat(samples, originalSampleRate, originalNumChans)
	return convertedSamples, nil
}

func (am *AudioMixer) convertToTargetFormat(samples []int, originalSampleRate, originalNumChans int) []int {
	if originalSampleRate == am.TargetSampleRate && originalNumChans == am.TargetNumChans {
		fmt.Printf("Format already matches target, no conversion needed\n")
		return samples
	}
	fmt.Printf("Converting from %dHz %dch to %dHz %dch\n",
		originalSampleRate, originalNumChans, am.TargetSampleRate, am.TargetNumChans)
	channelConverted := am.convertChannels(samples, originalNumChans, am.TargetNumChans)
	sampleRateConverted := am.convertSampleRate(channelConverted, originalSampleRate, am.TargetSampleRate, am.TargetNumChans)
	convertedDuration := float64(len(sampleRateConverted)) / float64(am.TargetSampleRate) / float64(am.TargetNumChans)
	fmt.Printf("Converted: %d samples, %.2f seconds at %d Hz, %d channels\n",
		len(sampleRateConverted), convertedDuration, am.TargetSampleRate, am.TargetNumChans)
	return sampleRateConverted
}

func (am *AudioMixer) convertChannels(samples []int, fromChans, toChans int) []int {
	if fromChans == toChans {
		return samples
	}
	if fromChans == 1 && toChans == 2 {
		result := make([]int, len(samples)*2)
		for i, sample := range samples {
			result[i*2] = sample
			result[i*2+1] = sample
		}
		return result
	}
	if fromChans == 2 && toChans == 1 {
		result := make([]int, len(samples)/2)
		for i := 0; i < len(samples); i += 2 {
			if i+1 < len(samples) {
				result[i/2] = (samples[i] + samples[i+1]) / 2
			}
		}
		return result
	}
	return samples
}

func (am *AudioMixer) convertSampleRate(samples []int, fromRate, toRate, numChans int) []int {
	if fromRate == toRate {
		return samples
	}
	ratio := float64(toRate) / float64(fromRate)
	inputFrames := len(samples) / numChans
	outputFrames := int(float64(inputFrames) * ratio)
	result := make([]int, outputFrames*numChans)
	for i := 0; i < outputFrames; i++ {
		srcFrame := int(float64(i) / ratio)
		if srcFrame >= inputFrames {
			srcFrame = inputFrames - 1
		}
		for ch := 0; ch < numChans; ch++ {
			result[i*numChans+ch] = samples[srcFrame*numChans+ch]
		}
	}
	return result
}

func (am *AudioMixer) saveToFile(samples []int, filename string) error {
	ext := filepath.Ext(filename)
	switch ext {
	case ".wav":
		return am.saveAsWav(samples, filename)
	case ".mp3":
		wavFile := filename[:len(filename)-len(ext)] + ".wav"
		if err := am.saveAsWav(samples, wavFile); err != nil {
			return err
		}
		fmt.Printf("Note: MP3 encoding requires external tools. WAV file created at: %s\n", wavFile)
		fmt.Printf("You can convert it to MP3 using FFmpeg: ffmpeg -i %s %s\n", wavFile, filename)
		return nil
	default:
		return am.saveAsWav(samples, filename)
	}
}

func (am *AudioMixer) saveAsWav(samples []int, filename string) error {
	outputFile, err := os.Create(filename)
	if err != nil {
		return fmt.Errorf("failed to create output file: %w", err)
	}
	defer outputFile.Close()
	format := &audio.Format{
		NumChannels: am.TargetNumChans,
		SampleRate:  am.TargetSampleRate,
	}
	buf := &audio.IntBuffer{
		Data:   samples,
		Format: format,
	}
	encoder := wav.NewEncoder(outputFile, am.TargetSampleRate, am.BitDepth, am.TargetNumChans, 1)
	defer encoder.Close()
	return encoder.Write(buf)
}
