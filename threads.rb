require 'pry'
do_this = 5
do_that = 5
and_the_other_thing = 5
threads = [do_this, do_that, and_the_other_thing]
threads.each do |item|
  Thread.new(item) do |sleep_number|
    sleep(sleep_number)
  end
end
