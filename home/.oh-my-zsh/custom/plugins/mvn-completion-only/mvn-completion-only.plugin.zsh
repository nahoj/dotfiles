# The official mvn plugin with half the stuff removed

function listMavenCompletions {
  local file new_file
  local -a profiles POM_FILES modules

  # Root POM
  POM_FILES=(~/.m2/settings.xml)

  # POM in the current directory
  if [[ -f pom.xml ]]; then
    local file=pom.xml
    POM_FILES+=("${file:A}")
  fi

  # Look for POM files in parent directories
  while [[ -n "$file" ]] && grep -q "<parent>" "$file"; do
    # look for a new relativePath for parent pom.xml
    new_file=$(grep -e "<relativePath>.*</relativePath>" "$file" | sed -e 's/.*<relativePath>\(.*\)<\/relativePath>.*/\1/')

    # if <parent> is present but not defined, assume ../pom.xml
    if [[ -z "$new_file" ]]; then
      new_file="../pom.xml"
    fi

    # if file doesn't exist break
    file="${file:h}/${new_file}"
    if ! [[ -e "$file" ]]; then
      break
    fi

    POM_FILES+=("${file:A}")
  done

  # Get profiles from found files
  for file in $POM_FILES; do
    [[ -e $file ]] || continue
    profiles+=($(sed 's/<!--.*-->//' "$file" | sed '/<!--/,/-->/d' | grep -e "<profile>" -A 1 | grep -e "<id>.*</id>" | sed 's?.*<id>\(.*\)<\/id>.*?-P\1?'))
  done

  # List modules
  modules=($(print -l **/pom.xml(-.N:h) | grep -v '/target/classes/META-INF/'))

  reply=(
    # common lifecycle
    clean initialize process-resources compile process-test-resources test-compile test package verify install deploy site

    # integration testing
    pre-integration-test integration-test

    # common plugins
    deploy failsafe install site surefire checkstyle javadoc archetype assembly

    # failsafe
    failsafe:integration-test failsafe:verify
    # install
    install:install-file install:help
    # surefire
    surefire:test

    # archetype
    archetype:generate archetype:create-from-project archetype:crawl
    # assembly
    assembly:single assembly:assembly
    # dependency
    dependency:analyze dependency:analyze-dep-mgt dependency:analyze-only dependency:analyze-report dependency:analyze-duplicate dependency:build-classpath dependency:copy dependency:copy-dependencies dependency:display-ancestors dependency:get dependency:go-offline dependency:list dependency:list-repositories dependency:properties dependency:purge-local-repository dependency:resolve dependency:resolve-plugins dependency:sources dependency:tree dependency:unpack dependency:unpack-dependencies
    # source
    source:aggregate source:jar source:jar-no-fork source:test-jar source:test-jar-no-fork

    # spring-boot
    spring-boot:run spring-boot:repackage
    # exec
    exec:exec exec:java

    # surefire-report
    surefire-report:failsafe-report-only surefire-report:report surefire-report:report-only

    # options
    "-Dmaven.test.skip=true" -DskipTests -DskipITs -Dmaven.surefire.debug -DenableCiProfile "-Dpmd.skip=true" "-Dcheckstyle.skip=true" "-Dtycho.mode=maven" "-Dmaven.test.failure.ignore=true" "-DgroupId=" "-DartifactId=" "-Dversion=" "-Dpackaging=jar" "-Dfile="

    # arguments
    -am --also-make
    -amd --also-make-dependents-am
    -B --batch-mode
    -b --builder
    -C --strict-checksums
    -c --lax-checksums
    -cpu --check-plugin-updates
    -D --define
    -e --errors
    -emp --encrypt-master-password
    -ep --encrypt-password
    -f --file
    -fae --fail-at-end
    -ff --fail-fast
    -fn --fail-never
    -gs --global-settings
    -gt --global-toolchains
    -h --help
    -l --log-file
    -llr --legacy-local-repository
    -N --non-recursive
    -npr --no-plugin-registry
    -npu --no-plugin-updates
    -nsu --no-snapshot-updates
    -o --offline
    -P --activate-profiles
    -pl --projects
    -q --quiet
    -rf --resume-from
    -s --settings
    -t --toolchains
    -T --threads
    -U --update-snapshots
    -up --update-plugins
    -v --version
    -V --show-version
    -X --debug

    archetype:generate generate-sources
    cobertura:cobertura
    -Dtest=$(if [ -d ./src/test/java ] ; then find ./src/test/java -type f -name '*.java' | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dtest=\1?' ; fi)
    -Dit.test=$(if [ -d ./src/test/java ] ; then find ./src/test/java -type f -name '*.java' | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dit.test=\1?' ; fi)

    $profiles
    $modules
  )
}

compctl -K listMavenCompletions mvn mvnd mvnw
