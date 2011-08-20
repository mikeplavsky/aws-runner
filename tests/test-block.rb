def run_on 
  puts yield
end

run_on do
  "Wow"
end
