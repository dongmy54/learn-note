package main

import (
	"errors"
	"fmt"
	"reflect"
)

// 用于从结构体/结构体指针中提取字段，并返回一个对应字段类型的切片
func ExtractField[T any](slice []T, fieldName string) (interface{}, error) {
	if len(slice) == 0 {
		// 返回一个长度为零的切片，而不是 nil
		return []interface{}{}, nil
	}

	var zero T
	elemType := reflect.TypeOf(zero)
	elemKind := elemType.Kind()
	isPtr := false

	// 判断元素类型是否为结构体或结构体指针
	if elemKind != reflect.Struct && elemKind != reflect.Ptr {
		return nil, errors.New("slice elements must be of struct or struct pointer type")
	}

	// 如果是指针，获取指向的结构体类型
	if elemKind == reflect.Ptr {
		isPtr = true
		elemType = elemType.Elem()
		if elemType.Kind() != reflect.Struct {
			return nil, errors.New("pointer does not point to struct")
		}
	}

	// 获取字段信息并缓存索引
	field, ok := elemType.FieldByName(fieldName)
	if !ok {
		return nil, fmt.Errorf("field %s not found in struct %s", fieldName, elemType.Name())
	}
	fieldIndex := field.Index

	// 创建结果切片
	resultType := reflect.SliceOf(field.Type)
	result := reflect.MakeSlice(resultType, 0, len(slice))

	for _, v := range slice {
		elem := reflect.ValueOf(v)
		if isPtr {
			elem = elem.Elem()
		}
		// 直接通过索引获取字段值
		fieldValue := elem.FieldByIndex(fieldIndex)
		result = reflect.Append(result, fieldValue)
	}

	return result.Interface(), nil
}

func main() {
	type Person struct {
		Name string
		Age  int
	}

	people := []Person{
		{Name: "Alice", Age: 30},
		{Name: "Bob", Age: 25},
	}

	peoplePtr := []*Person{
		{Name: "Charlie", Age: 35},
		{Name: "Diana", Age: 32},
	}

	names, err := ExtractField(people, "Name")
	if err != nil {
		fmt.Println("Error:", err)
	} else {
		fmt.Println("Names:", names)
	}

	ages, err := ExtractField(people, "Age")
	if err != nil {
		fmt.Println("Error:", err)
	} else {
		fmt.Println("Ages:", ages)
	}

	namesPtr, err := ExtractField(peoplePtr, "Name")
	if err != nil {
		fmt.Println("Error:", err)
	} else {
		fmt.Println("Names (ptr):", namesPtr)
	}

	agesPtr, err := ExtractField(peoplePtr, "Age")
	if err != nil {
		fmt.Println("Error:", err)
	} else {
		fmt.Println("Ages (ptr):", agesPtr)
	}
}
