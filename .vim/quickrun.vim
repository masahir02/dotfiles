let g:quickrun_config = {
\ '_': {
\   'outputter/buffer/split': '',
\   'outputter/buffer/close_on_empty': 1,
\ },
\ 'ruby.bundle': {
\   'command': 'ruby',
\   'cmdopt': 'bundle exec',
\   'exec': '%o %s %c',
\ },
\}
