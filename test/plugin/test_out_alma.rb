require 'helper'

class AlmaOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf=CONFIG, tag='test')
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::AlmaOutput, tag).configure(conf)
  end

  CONFIG = %[
      alma            localhost:11235
      connect_timeout 5
      send_timeout    5
      receive_timeout 5
  ]

  def test_configure
    assert_raise(Fluent::ConfigError) do
      create_driver(CONFIG)
    end

    d = create_driver(CONFIG + %[target test])

    assert_equal 'localhost:11235', d.instance.alma
    assert_equal 'localhost', d.instance.host
    assert_equal 11235, d.instance.port
    assert_equal "test", d.instance.target
    assert_equal 5, d.instance.connect_timeout
    assert_equal 5, d.instance.send_timeout
    assert_equal 5, d.instance.receive_timeout
  end

  def test_format
    d = create_driver(CONFIG + %[target dena])

    time = Time.parse("2011-01-01 11:22:33 UTC").to_i
    d.emit({data: "test"}, time)

    d.expect_format ["test", time.to_i,{data: "test"}].to_msgpack
    d.run
  end

end
