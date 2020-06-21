resource_extensions = ["storyboard" ,"xib", "xcassets", "html", "xcdatamodeld", "json", "ttf", "lproj"]

def swift_copts():
  return [
    "-whole-module-optimization", # faster compilation (see https://www.skilled.io/u/swiftsummit/swift-with-a-hundred-engineers)
    "-swift-version", "5",
    "-DDEBUG", # Enable the DEBUG flag, for using it in macros
    "-Onone", # Do not make optimizations: compilation is faster
    "-g", # Generate debug information
  ]
