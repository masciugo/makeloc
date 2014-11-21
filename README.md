# Makeloc
A little generator to tidy locale files along with their content for Ruby On Rails

## Idea
Makeloc comes from the necessity to update or create locale files while developing Ruby on Rails application. Often there is a reference language which get manually updated whenever necessary and later all the other locales should follow the same update steps. This last part could be very tedious and prone to errors or missings. 

Makeloc, given a reference filepath (formatted as `path/to/file/context.reference_lang.yml`) and a target language, creates, in the same folder, a corresponding locale file `path/to/file/context.target_lang.yml` with same keys. If the target file already exists it gets updated. It actually get recreated with the same structure (same keys set) of the reference one and then updated with old values. This means that keys in the old target locale file not present in the reference one will be wiped out after generation.

## Installation
    gem install makeloc

## Usage
Makeloc is a generator. The following will create, or update if it exists, the file `config/locales/activerecord.it.yml`

    rails g makeloc:do it config/locales/activerecord.en.yml [--strict]

with option --strict, in case of update, it deletes any extra keys in the destination locale file

## Test

    rake spec

## Contributing

Comments and feedback are welcome

----
Copyright (c) 2014 masciugo. See LICENSE.txt for
further details.
