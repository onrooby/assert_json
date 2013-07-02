require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class AssertJsonNewDslTest < Test::Unit::TestCase
  include AssertJson::Assertions

  def test_string
    assert_json '"key"' do |j|
      j.has 'key'
    end
  end
  def test_string_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '"key"' do |j|
        j.has 'wrong_key'
      end
    end
  end
  def test_regular_expression_for_strings
    assert_json '"string"' do |j|
      j.has /tri/
    end
  end
  def test_regular_expression_for_hash_values
    assert_json '{"key":"value"}' do |j|
      j.has 'key', /alu/
    end
  end
  
  def test_single_hash
    assert_json '{"key":"value"}' do |j|
      j.has 'key', 'value'
    end
  end
  def test_single_hash_with_outer_variable
    @values = {'value' => 'value'}
    assert_json '{"key":"value"}' do |j|
      j.has 'key', @values['value']
    end
  end
  def test_single_hash_crosscheck_for_key
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":"value"}' do |j|
        j.has 'wrong_key', 'value'
      end
    end
  end
  def test_single_hash_crosscheck_for_value
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":"value"}' do |j|
        j.has 'key', 'wrong_value'
      end
    end
  end
  
  def test_has_not
    assert_json '{"key":"value"}' do |j|
      j.has 'key', 'value'
      j.has_not 'key_not_included'
    end
  end
  def test_has_not_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":"value"}' do |j|
        j.has_not 'key'
      end
    end
  end
  
  def test_array
    assert_json '["value1","value2","value3"]' do |j|
      j.has 'value1'
      j.has 'value2'
      j.has 'value3'
    end
  end
  def test_has_not_array
    assert_json '["value1","value2"]' do |j|
      j.has 'value1'
      j.has 'value2'
      j.has_not 'value3'
    end
  end
  def test_array_crosscheck_order
    assert_raises(MiniTest::Assertion) do
      assert_json '["value1","value2","value3"]' do |j|
        j.has 'value2'
      end
    end
  end
  def test_array_crosscheck_for_first_item
    assert_raises(MiniTest::Assertion) do
      assert_json '["value1","value2","value3"]' do |j|
        j.has 'wrong_value1'
      end
    end
  end
  def test_array_crosscheck_for_second_item
    assert_raises(MiniTest::Assertion) do
      assert_json '["value1","value2","value3"]' do |j|
        j.has 'value1'
        j.has 'wrong_value2'
      end
    end
  end
  
  def test_nested_arrays
    assert_json '[[["deep","another_depp"],["second_deep"]]]' do |j|
      j.has [["deep","another_depp"],["second_deep"]]
    end
  end
  def test_nested_arrays_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '[[["deep","another_depp"],["second_deep"]]]' do |j|
        j.has [["deep","wrong_another_depp"],["second_deep"]]
      end
    end
    assert_raises(MiniTest::Assertion) do
      assert_json '[[["deep","another_depp"],["second_deep"]]]' do |j|
        j.has [["deep","another_depp"],["wrong_second_deep"]]
      end
    end
  end
  
  def test_hash_with_value_array
    assert_json '{"key":["value1","value2"]}' do |j|
      j.has 'key', ['value1', 'value2']
    end
  end
  def test_hash_with_value_array_crosscheck_wrong_key
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":["value1","value2"]}' do |j|
        j.has 'wrong_key', ['value1', 'value2']
      end
    end
  end
  def test_hash_with_value_array_crosscheck_wrong_value1
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":["value1","value2"]}' do |j|
        j.has 'key', ['wrong_value1', 'value2']
      end
    end
  end
  def test_hash_with_value_array_crosscheck_wrong_value2
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":["value1","value2"]}' do |j|
        j.has 'key', ['value1', 'wrong_value2']
      end
    end
  end
  
  def test_hash_with_array_of_hashes
    assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do |j|
      j.has 'key' do |j|
        j.has 'inner_key1', 'value1'
        j.has 'inner_key2', 'value2'
      end
    end
  end
  def test_hash_with_array_of_hashes_crosscheck_inner_key
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do |j|
        j.has 'key' do |j|
          j.has 'wrong_inner_key1', 'value1'
        end
      end
    end
  end
  def test_hash_with_array_of_hashes_crosscheck_inner_value
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do |j|
        j.has 'key' do |j|
          j.has 'inner_key1', 'wrong_value1'
        end
      end
    end
  end
  
  def test_array_with_two_hashes
    assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do |j|
      j.has 'key1', 'value1'
      j.has 'key2', 'value2'
    end
  end
  def test_array_with_nested_hashes
    assert_json '[{"key1":{"key2":"value2"}}]' do |j|
      j.has 'key1' do
        j.has 'key2', 'value2'
      end
    end
  end
  def test_array_with_two_hashes_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do |j|
        j.has 'wrong_key1', 'value1'
        j.has 'key2', 'value2'
      end
    end
    assert_raises(MiniTest::Assertion) do
      assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do |j|
        j.has 'key1', 'value1'
        j.has 'key2', 'wrong_value2'
      end
    end
  end
  
  def test_nested_hashes
    assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do |j|
      j.has 'outer_key' do |j|
        j.has 'key' do |j|
          j.has 'inner_key', 'value'
        end
      end
    end
  end
  def test_nested_hashes_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do |j|
        j.has 'wrong_outer_key'
      end
    end
    assert_raises(MiniTest::Assertion) do
      assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do |j|
        j.has 'outer_key' do |j|
          j.has 'key' do |j|
            j.has 'inner_key', 'wrong_value'
          end
        end
      end
    end
  end
  
  def test_real_xws
    assert_json '[{"contact_request":{"sender_id":"3","receiver_id":"2","id":1}}]' do |j|
      j.has 'contact_request' do |j|
        j.has 'sender_id', '3'
        j.has 'receiver_id', '2'
        j.has 'id', 1
      end
    end
  
    assert_json '[{"private_message":{"sender":{"display_name":"first last"},"receiver_id":"2","body":"body"}}]' do |j|
      j.has 'private_message' do |j|
        j.has 'sender' do |j|
          j.has 'display_name', 'first last'
        end
        j.has 'receiver_id', '2'
        j.has 'body', 'body'
      end
    end
  end
  
  def test_not_enough_hass_in_array
    assert_raises(MiniTest::Assertion) do
      assert_json '["one","two"]' do |j|
        j.has "one"
        j.has "two"
        j.has "three"
      end
    end
  end
  
  def test_not_enough_hass_in_hash_array
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":[{"key1":"value1"}, {"key2":"value2"}]}' do |j|
        j.has 'key' do
          j.has 'key1', 'value1'
          j.has 'key2', 'value2'
          j.has 'key3'
        end
      end
    end
  end
  
  def test_assertion_raises_without_block
    assert_raises(MiniTest::Assertion) do
      assert_json '{ "foo": 445 '
    end
  end
end
