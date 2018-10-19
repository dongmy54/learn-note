# ARGV 
# 1、命令行传入参数
# 2、数组

# $ruby 特殊量.rb ab cd
puts ARGV.inspect     # ["ab", "cd"]  



# gets
# 运行中获取参数
# (PS: 用gets不能传命令行参数)
temp_arg = gets.chomp
puts temp_arg


# ENV
# 1、存环境信息
# 2、hash
puts ENV.inspect
# {"TERM_SESSION_ID"=>"w0t1p0:32B701D6-B896-4F7C-A7CD-D1CEF2F6919A", "SSH_AUTH_SOCK"=>"/private/tmp/com.apple.launchd.Bz0EjLQJCG/Listeners", "Apple_PubSub_Socket_Render"=>"/private/tmp/com.apple.launchd.uxpj3b4lxB/Render", "COLORFGBG"=>"12;8", "ITERM_PROFILE"=>"Default", "XPC_FLAGS"=>"0x0", "LANG"=>"zh_CN.UTF-8", "PWD"=>"/Users/dmy/learn-note/ruby/\xE8\xAF\xAD\xE6\xB3\x95", "SHELL"=>"/bin/zsh", "TERM_PROGRAM_VERSION"=>"3.2.3", "TERM_PROGRAM"=>"iTerm.app", "PATH"=>"/Users/dmy/.rvm/gems/ruby-2.3.3/bin:/Users/dmy/.rvm/gems/ruby-2.3.3@global/bin:/Users/dmy/.rvm/rubies/ruby-2.3.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/dmy/.rvm/bin", "COLORTERM"=>"truecolor", "TERM"=>"xterm-256color", "HOME"=>"/Users/dmy", "TMPDIR"=>"/var/folders/nn/bb0v7zz50d17szpw8q2fncdm0000gn/T/", "USER"=>"dmy", "XPC_SERVICE_NAME"=>"0", "LOGNAME"=>"dmy", "__CF_USER_TEXT_ENCODING"=>"0x1F5:0x19:0x34", "ITERM_SESSION_ID"=>"w0t1p0:32B701D6-B896-4F7C-A7CD-D1CEF2F6919A", "SHLVL"=>"1", "OLDPWD"=>"/Users/dmy/learn-note", "ZSH"=>"/Users/dmy/.oh-my-zsh", "PAGER"=>"less", "LESS"=>"-R", "LC_CTYPE"=>"zh_CN.UTF-8", "LSCOLORS"=>"Gxfxcxdxbxegedabagacad", "rvm_prefix"=>"/Users/dmy", "rvm_path"=>"/Users/dmy/.rvm", "rvm_bin_path"=>"/Users/dmy/.rvm/bin", "_system_type"=>"Darwin", "_system_name"=>"OSX", "_system_version"=>"10.13", "_system_arch"=>"x86_64", "rvm_version"=>"1.29.4 (latest)", "GEM_HOME"=>"/Users/dmy/.rvm/gems/ruby-2.3.3", "GEM_PATH"=>"/Users/dmy/.rvm/gems/ruby-2.3.3:/Users/dmy/.rvm/gems/ruby-2.3.3@global", "MY_RUBY_HOME"=>"/Users/dmy/.rvm/rubies/ruby-2.3.3", "IRBRC"=>"/Users/dmy/.rvm/rubies/ruby-2.3.3/.irbrc", "RUBY_VERSION"=>"ruby-2.3.3", "rvm_alias_expanded"=>"", "rvm_bin_flag"=>"", "rvm_docs_type"=>"", "rvm_gemstone_package_file"=>"", "rvm_gemstone_url"=>"", "rvm_niceness"=>"", "rvm_nightly_flag"=>"", "rvm_only_path_flag"=>"", "rvm_pretty_print_flag"=>"", "rvm_proxy"=>"", "rvm_quiet_flag"=>"", "rvm_ruby_bits"=>"", "rvm_ruby_file"=>"", "rvm_ruby_make"=>"", "rvm_ruby_make_install"=>"", "rvm_ruby_mode"=>"", "rvm_script_name"=>"", "rvm_sdk"=>"", "rvm_silent_flag"=>"", "rvm_use_flag"=>"", "rvm_hook"=>"", "_"=>"/Users/dmy/.rvm/rubies/ruby-2.3.3/bin/ruby"}
ENV['hubar'] = 'kkop'
puts ENV['hubar']    # kkop




