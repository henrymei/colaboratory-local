#!/bin/sh
jupyter serverextension enable --py jupyter_http_over_ws
jupyter notebook \
  --ip 0.0.0.0 \
  --port 8888 \
  --no-browser \
  --allow-root \
  --NotebookApp.token='' \
  --NotebookApp.allow_origin='https://colab.research.google.com' \
  --NotebookApp.port_retries=0
