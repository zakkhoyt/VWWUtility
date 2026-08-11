

This directory should contain `links` or `symbolic links` to reference documents which are useful for AI context, but which should NOT be committed into the target repository





<!-- 
* [ ] AI Agent to populate with information about what belongs in this directory
    * This directory should contain `links` or `symbolic links` to reference documents which are useful for AI context, but which should NOT be committed into the target repository
    * if the target dir is nested under a `.gitignored/` directory (and the .gitignore file knows to ignore .gitignored), then none of this dir hierachy will be committed
    * EX: $repo_dir/.gitignored/docs/.ai/planning/... # no part of docs/.ai/planning will be committed to the repository
    * EX: $repo_dir/docs/.ai/planning/... # All of docs/.ai/planning will be committed to the repository. 
      * True that symbolic links will only be worth while when checked out on the same machine that committed it (in most cases), but is better than committing unwanted/personal files
        * If you DO want to commit your note files, create a dir: `docs/.ai/planning/notes`
-->

