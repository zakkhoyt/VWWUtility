

This directory (`$output_dir/docs/.ai/planning/planning_references`) is a directory that should contain only symbolic links to other directories or files. 
The purpose of nesting symlinks under `planning_references` dir is:
* To give AI Agents access to those resources without committing them to the repository
* Visual Studio Code is configured to treat dirs named `planning_references` in a special way
  * It does not index the files/dirs underneath
  * It does not search the files/dirs underneath
  * It only displays the top 5 dir layers or so
* All of the above are to prevent VSCode from spending unnecesary CPU cycles on that work, and believe me it can really take a persistant toll on computer resources. 



```jsonc
// from VSCode user settings: ~/Library/Application Support/Code/User/settings.json
{
  "files.exclude": {
    "**/planning_references/*/*/*/*/*/*/**": true,
    "**/symlinks/*/*/*/*/*/*/**": true,
    // ...
  },
  "search.exclude": {
    "**/planning_references/*/*/*/*/*/*/**": true,
    "**/symlinks/*/*/*/*/*/*/**": true,
    // ...
  },
  "files.watcherExclude": {
    "**/planning_references/*/*/*/*/*/*/**": true,
    "**/symlinks/*/*/*/*/*/*/**": true,
    // ...
  }  
}
```




<!-- 
* [ ] AI Agent to populate with information about the file hierarchy in this directory
  * See: `$HOME/code/repositories/hatch/hatch_sleep/scripts/shell/_packages/ai_planning/docs/defines/AI_PLANNING_DEFINES.md` 
-->

