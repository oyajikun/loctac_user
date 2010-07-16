namespace :carrier_gateway do
  require 'yaml'
  require 'open-uri'
  require 'hpricot'

  def save_to_yaml(ipaddrs, carrier)
    File.open(File.join(RAILS_ROOT, 'config', 'carrier_gateway.yml'), File::RDWR|File::CREAT) do |fh|
      fh.flock(File::LOCK_EX)
      db = YAML.load(fh) || {}
      db[carrier] = ipaddrs
      fh.truncate(0)
      fh.rewind
      fh << db.to_yaml
    end
  end

  desc 'get carrier gateway ip addr'
  task :update => %w|update:docomo update:au update:softbank|

  namespace :update do
    desc 'get docomo gateway ip addr'
    task :docomo do
      ipaddrs = []
      doc = Hpricot(open('http://www.nttdocomo.co.jp/service/imode/make/content/ip/'))
      doc.search('//ul[@class="normal txt"]/li').each do |elem|
        if m = elem.inner_html.match(%r|^\s*(\d+\.\d+\.\d+\.\d+/\d+)\s*$|)
          ipaddrs << m[1]
        end
      end
      return puts 'IP addresses was unacquirable.' if ipaddrs.empty?
      save_to_yaml ipaddrs, 'docomo'
    end

    desc 'get au gateway ip addr'
    task :au do
      ipaddrs = []
      doc = Hpricot(open('http://www.au.kddi.com/ezfactory/tec/spec/ezsava_ip.html'))
      doc.search('//tr/td[2]/div[@class="TableText"]').each do |elem|
        if m = elem.inner_html.match(%r|^\s*(\d+\.\d+\.\d+\.\d+)\s*$|)
          addr = m[1]
          n = elem.parent.next_sibling.at('div[@class="TableText"]')
          if m = n.inner_html.match(%r|^\s*(/\d+)\s*$|)
            mask = m[1]
            ipaddrs << addr + mask
          end
        end
      end
      return puts 'IP addresses was unacquirable.' if ipaddrs.empty?
      save_to_yaml ipaddrs, 'au'
    end

    desc 'get softbank gateway ip addr'
    task :softbank do
      ipaddrs = []
      doc = Hpricot(open('http://creation.mb.softbank.jp/web/web_ip.html'))
      doc.search('//td').each do |elem|
        if m = elem.inner_html.match(%r[^(?:\&nbsp;|\s)*(\d+\.\d+\.\d+\.\d+/\d+)(?:\&nbsp;|\s)*$])
          ipaddrs << m[1]
        end
      end
      return puts 'IP addresses was unacquirable.' if ipaddrs.empty?
      save_to_yaml ipaddrs, 'softbank'
    end
  end
end
