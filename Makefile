prereqs:
	sudo yum install -y wget curl zip python-pip gcc zlib-devel libxml2 libxslt rpm-build gcc-c++ libffi-devel redhat-rpm-config

rvm:
	echo "Installing rvm..."
	# gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
	command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
	\curl -sSL https://get.rvm.io | bash -s stable

ruby:
	echo "Installing ruby..."
	rvm install 2.7.3
	# NOTE: rvm use not working
	# rvm alias create default 2.7.3
	rvm use 2.7.3
	$(rvm 2.7.3 do rvm env --path)
	ruby --version

gem: ruby
	echo "Installing bundler..."
	gem install bundle bundler

bundle: gem
	echo "Installing bundle..."
	bundle install --full-index --path vendor/bundle

pipenv:
	echo "Create pipenv environment"
	pipenv install -d

init: rvm ruby gem bundle pipenv
	echo "Initializing..."

lint:
	echo "Linting..."
	pipenv run yamllint _data/

clean:
	echo "Cleaning..."
	rm -rf build/ _site/

clean-all: clean
	echo "Cleaning..."
	rm -rf .bundle/ .venv/ vendor/

build:
	echo "Building..."
	mkdir -p build/
	bundle exec jekyll build

serve:
	echo "Starting server..."
	bundle exec jekyll serve --host 0.0.0.0 --port 8080
