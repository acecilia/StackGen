import Foundation
import Path

// We require to split this into Raw and not Raw because of https://forums.swift.org/t/decoding-a-dictionary-with-a-custom-key-type/35290

typealias TemplatesFileRaw = [String: TemplateSpec]
typealias TemplatesFile = [Path: TemplateSpec]
