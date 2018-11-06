module Proofer
  # Constants to be used in options
  FILE_IGNORE = %w[
    videos
    swagger
    mftf
    pattern-library
    guides/m1x
    search.html
    404.html
    codelinks
    magento-third-party.html
    magento-techbull.html
    release-notes
    index.html
    template.html
    whats-new.html
    action-groups.html
    css-preprocess.html
    es-overview.html
    cloud-fastly.html
    theme_dictionary.html
    contributing.html
  ].freeze

  URL_IGNORE = %w[
    guides/v2.0
    architecture
    advanced-reporting
    coding-standards
    comp-mgr
    config-guide
    contributor-guide
    design-styleguide
    ext-best-practices
    extension-dev-guide
    frontend-dev-guide
    get-started
    graphql
    howdoi
    inventory
    javascript-dev-guide
    marketplace
    magento-functional-testing-framework
    migration
    modules
    mrg
    mtf
    pattern-library
    payments-integrations
    release-notes
    rest
    soap
    test
    ui-components
    ui_comp_guide
    pwa
    msi
    mftf
    github.com
    www.thegeekstuff.com
    account.magento.com
    yatil.net
    ui-library
    security
    navigation
    community
    docs.magento.com
    mariadb.com
  ].freeze

  # Configure htmlproofer parameters:
  def options
    {
      log_level: :info,
      only_4xx: true,
      # external_only: true, # Check external links only
      checks_to_ignore: %w[ScriptCheck ImageCheck],
      allow_hash_ref: true,
      alt_ignore: [/.*/],
      file_ignore: array_to_re(FILE_IGNORE),
      url_ignore: array_to_re(URL_IGNORE),
      error_sort: :desc, # Sort by invalid link instead of affected file path (default). This makes it easier to see how many files the broken link affects.
      parallel: { in_processes: 3 },
      typhoeus: { followlocation: true, connecttimeout: 10, timeout: 30 },
      hydra: { max_concurrency: 50 },
      # cache: { :timeframe => '30d' }
    }
  end

  # Convert array of strings to array of regular expressions
  def array_to_re(array)
    array.map { |item| /#{item}/ }
  end

  # Count the number of lines in the given file
  def size_in_lines(filepath)
    f = File.new(filepath)
    f.readlines[-1]
    count = f.lineno.to_s
    puts "#{count} lines in the #{File.basename(filepath)} file.".blue
  end

  # Read the current Git branch
  def current_branch
    `git symbolic-ref --short HEAD`.strip
  end

  # Name the directory for the link checker reports
  def dir_name
    'tmp/.htmlproofer/'
  end

  # Name the file for the link checker report
  def file_name
    prefix = "broken-links-in-"
    timestamp = Time.now.strftime("_%m-%d_%H-%M-%S")
    prefix + current_branch + timestamp
  end

  # Relative path for the link checker report
  def file_path
    dir_name + file_name
  end

  def md_report_path
    file_path + '.md'
  end
end
