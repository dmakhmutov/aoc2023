fmt:
	bundle exec standardrb --fix
run:
	bundle exec ruby days/$(DAY)/main.rb
add:
	cp -r days/template days/$(DAY) && \
	curl --cookie "session=$(AOC_SESSION)" https://adventofcode.com/2023/day/$(DAY)/input > days/$(DAY)/input.txt
