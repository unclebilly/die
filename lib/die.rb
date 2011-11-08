require 'optparse'

class Die
  attr_accessor :signal, :search

  def kill_phash_entry(entry)
    pid = entry[0].strip.to_i
    Process.kill(self.signal, pid)
    puts "#{self.signal} #{pid} #{entry[1]}"
  end

  def processes
    @processes ||= `ps -ae -o pid,command | egrep -i '(#{self.search.join("|")})' | egrep -v \"(#{$0}|grep)\"`.split("\n").map(&:strip)
  end

  # {
  #   1 =>	["1545", "/Applications/Firefox.app/Contents/MacOS/firefox-bin -psn_0_139298"],
  #   2 =>	["1546", "/Applications/Firefox.app/Contents/MacOS/firefox-bin -psn_0_139298"]
  # }
  def process_hash
    p_hash = {}
    processes.each_with_index do |p,i|
      p_hash[i+1] = p.split
      processes[i] = "#{i+1}.\t#{p[0..150]}"
    end
    p_hash
  end

  def initialize(opts={})
    self.signal = (opts[:signal] || "KILL").upcase
    if !Signal.list.has_key?(self.signal)
      raise Exception.new "Unknown signal #{self.signal}. Available signals: #{Signal.list.keys.sort.join(", ")}"
    end
    self.search = opts[:search] || ""
  end

  def run
    unless processes.empty?
      p_hash = process_hash
      puts
      puts processes
      puts
      puts " Type 'all' to #{self.signal} 'em all, or the numbers (separated by a space) to kill some. Type anything else to quit."
      inp = $stdin.gets.strip
      if(inp =~ /^a(ll)?/i)
        p_hash.each do |k,v|
          kill_phash_entry(v)
        end
      elsif(inp =~ /[\d\s]{1,}/)
        inp.split.each do |num|
          kill_phash_entry(p_hash[num.to_i])
        end
      end
    else
      puts "No processes matching #{ARGV[0]}"
    end
  end

  def self.run_from_options
    opts = {:signal => "KILL", :search => ARGV[0..-1]}
    o = OptionParser.new do |opt|
      opt.banner = self.help
      opt.on("-v", "--version", "Show version") do
        puts "#{self.to_s} #{File.read(File.join(File.dirname(__FILE__, '..', 'VERSION')))}"
        exit
      end
      opt.on("-s", "--signal SIGNAL", "Signal (defaults to KILL)") do |sig|
        puts sig, '00' * 100
        opts[:signal] = sig
      end
    end
    o.parse!
    self.new(opts).run
  end

  def self.help
    <<-STR
Description
Kill (or send a different signal to) one or more processes by search string. 
Multiple search strings can be provided, separated by a space.  
The default signal is KILL; a different one can be provided with the
-s switch (see below).

Usage
#{$0} search_string1 [...search_string2 [...]]

Available signals
#{Signal.list.keys.join(", ")}

Options
    STR
  end
end
