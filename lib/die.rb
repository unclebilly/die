class Die
  def kill_phash_entry(entry)
    pid = entry[0].strip.to_i
    Process.kill("KILL", pid)
    puts "Killed #{pid} #{entry[1]}"
  end

  def processes
    @processes ||= `ps -ae -o pid,command | grep -i #{ARGV[0]} | egrep -v "(#{$0}|grep)"`.split("\n").map(&:strip)
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

  def run
    unless processes.empty?
      p_hash = process_hash

      puts
      puts processes
      puts
      puts " Type 'all' to kill 'em all, or the numbers (separated by a space) to kill some. Type anything else to quit."
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
end
