#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Fetches Hadoop build and runtime dependencies.

set -e -u -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR/../.." || exit 1

# fetch plugins, even if not part of regular build
./mvnw dependency:resolve-plugins help:help "$@"

# regular build to work around bug in dependency:go-offline
# https://github.com/apache/maven-dependency-plugin/issues/1803
./mvnw clean verify \
  -Denforcer.skip \
  -Djacoco.skip \
  -Dmaven.javadoc.skip \
  -Dmdep.analyze.skip \
  -DskipShade \
  -Dtest=void \
  "$@"
