require 'helper'

class TestDie < Test::Unit::TestCase
  def setup
    @out = $stdout
    $stdout = StringIO.new
  end

  def teardown
    $stdout = @out
  end

  def test_process_hash
    d = Die.new
    ps = [
      "42 /usr/sbin/httpd -D FOREGROUND",
      "249 /usr/sbin/httpd -D FOREGROUND"
    ]
    d.stubs(:processes).returns(ps)
    expected = {
      1 => ["42", "/usr/sbin/httpd", "-D", "FOREGROUND"],
      2 => ["249", "/usr/sbin/httpd", "-D", "FOREGROUND"]
    }
    assert_equal(expected, d.process_hash)
  end

  def test_run_one_kill
    d = Die.new
    d.stubs(:processes).returns([
      "42 /usr/sbin/httpd -D FOREGROUND",
      "249 /usr/sbin/httpd -D FOREGROUND"
    ])
    d.stubs(:process_hash).returns({
      1 => ["42", "/usr/sbin/httpd", "-D", "FOREGROUND"],
      2 => ["249", "/usr/sbin/httpd", "-D", "FOREGROUND"]
    })
    $stdin.stubs(:gets).returns("1")
    Process.expects(:kill).with("KILL", 42)
    d.run
  end

  def test_run_multiple_kills
    d = Die.new
    d.stubs(:processes).returns([
      "42 /usr/sbin/httpd -D FOREGROUND",
      "249 /usr/sbin/httpd -D FOREGROUND"
    ])
    d.stubs(:process_hash).returns({
      1 => ["42", "/usr/sbin/httpd", "-D", "FOREGROUND"],
      2 => ["249", "/usr/sbin/httpd", "-D", "FOREGROUND"]
    })
    $stdin.stubs(:gets).returns("1 2")
    Process.expects(:kill).with("KILL", 42)
    Process.expects(:kill).with("KILL", 249)
    d.run
  end
end
