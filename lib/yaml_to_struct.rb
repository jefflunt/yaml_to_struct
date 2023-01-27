require 'psych'

# YamlToStruct
#
# This module provides a way to convert YAML string to a nested Struct. It
# converts the YAML keys to Symbols before sending them to the Struct for
# initialization.
#
# Example:
#   yaml_string = 'foo: {bar: {baz: 1}}'
#   struct = YamlToStruct.load(yaml_string)
#   struct.foo.bar.baz #=> 1

module YamlToStruct
  def self.load(yaml_string)
    yaml = Psych.load(yaml_string)
    _load_helper(yaml)
  end

  def self._load_helper(yaml)
    case yaml
    when Hash
      struct = ::Struct.new(*yaml.keys.map(&:to_sym))
      struct.new(*yaml.values.map { |v| _load_helper(v) })
    when Array
      yaml.map { |v| _load_helper(v) }
    else
      yaml
    end
  end
end

