require("cmake-tools").setup({
  cmake_command = "cmake",
  cmake_build_directory = "build",
  cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
})
