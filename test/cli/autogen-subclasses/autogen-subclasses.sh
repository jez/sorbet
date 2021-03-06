#!/bin/bash
set -eu

echo "--- autogen-subclasses ---"
main/sorbet --silence-dev-message --stop-after=namer -p autogen-subclasses \
  --autogen-subclasses-parent=Opus::Mixin \
  --autogen-subclasses-parent=Opus::Parent \
  --autogen-subclasses-parent=Opus::SafeMachine \
  --autogen-subclasses-parent=Chalk::ODM::Model \
  --autogen-subclasses-parent=Opus::IDontExist \
  --autogen-subclasses-parent=Opus::NeverSubclassed \
  test/cli/autogen-subclasses/a.rb
