PLEASE, DON'T FORGET TO RUN MIGRATIONS
### completed features:
- Card 101. A contract supplier is always present in the main table. (Please run the migrations).
Index and Supplier actions eager load contract owners to avoid N+1 queries during owner name render. (BONUS exercise)
- Card 102. Modal is opened via TurboFrame from the contracts index. CSV gets imported. Stimulus JS handles modal state, like: attached file, uploading process, TurboStream process is complete. Once the DB is updated, only the Contract rows are updated with Turbo Stream. CSV file is parsed and records are created or updated with #upsert_all method for performance reasons. Detailed description of how CsvContractImportService works is here: https://github.com/dmitryjum/TropicContracts/pull/8. Validation errors and counter of updated or created records are rendered in the flash popups on the page via Turbo Stream.
- Card 103. A contract supplier is a turbo frame link that uses fuzzy search over gin indexed Supplier (BONUS exercise).
- Card 104. Average contract value by supplier is rendered
- 
##### Bonus points:
- `If a similar supplier name exists in the database already, use the existing supplier`: it works based on the text search, but it isn't precise, because it's hard to predict which name is the real name
- `Use Hotwire to avoid a page refresh or redirect when importing contracts by live streaming the updates to the page.` - Done
- `Find and remove any N+1 queries in the app.` - Done
- `Refactoring` - Applied pagination, in case of highly large number of records. CSV rows are parsed in batches of 500 and upserted in minimal possible queries, hence done in real time and UI is expected to refresh in real time. I haven't added view specs to save time (it can be manually tested). But I've added tests for new Contract model methods and for CsvContractImportService functinality (it could probably be even more extensive, but would work as is for now).
##### How can it be improved, or what else could be done:
- CSV parsing should be done in the background job in my opinion. Rerendering table instantly may not be absolutely necessary for performance preservation reasons.
- Rubocop, ESLint and Prettier could be installed additionally to lint Ruby, JS and sort Tailwind CSS classes
- Brakeman gem can be installed to test security vulnarabilites in Rails application
- jemalloc gem can be installed to memory allocation improvement if needed
##### Unsolved issues:
I couldn't extract exact FontAwesome icons from Figma, but found as good looking substitutions.