namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD..") { %x(rails db:drop) }
      show_spinner("Criando Banco de Dados .....") { %x(rails db:create) }
      show_spinner("Migrando Tabelas .....") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc "Cadastra as Moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando Moedas") do
      coins = [
        {
          description: "Bitcoin",
          acronym: "BTC",
          url_image: "https://www.google.com/imgres?imgurl=http%3A%2F%2Fpngimg.com%2Fuploads%2Fbitcoin%2Fbitcoin_PNG48.png&imgrefurl=http%3A%2F%2Fpngimg.com%2Fimgs%2Flogos%2Fbitcoin%2F&docid=qjd08FnsZJHiuM&tbnid=YSySejCR1ggUzM%3A&vet=10ahUKEwjfqKzxxLbfAhWLC5AKHbjfA-kQMwg9KAAwAA..i&w=968&h=968&bih=896&biw=1270&q=bitcoin%20png&ved=0ahUKEwjfqKzxxLbfAhWLC5AKHbjfA-kQMwg9KAAwAA&iact=mrc&uact=8",
          mining_type: MiningType.find_by(acronym: "PoW"),
        },
        {
          description: "Ethereum",
          acronym: "ETH",
          url_image: "https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.redd.it%2Fbfo1798dlo7z.png&imgrefurl=https%3A%2F%2Fwww.reddit.com%2Fr%2Fethtrader%2Fcomments%2F6lb750%2Fhere_is_a_png_file_i_designed_of_ethereum_for_fun%2F&docid=BS9sJtnm5CVVyM&tbnid=At9o1FTg7XvSkM%3A&vet=10ahUKEwj84dP6xLbfAhUDk5AKHfE5D_0QMwhCKAIwAg..i&w=658&h=1056&bih=896&biw=1270&q=etherium%20png&ved=0ahUKEwj84dP6xLbfAhUDk5AKHfE5D_0QMwhCKAIwAg&iact=mrc&uact=8",
          mining_type: MiningType.all.sample,
        },
        {
          description: "Dash",
          acronym: "DASH",
          url_image: "https://www.google.com/url?sa=i&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwiG8p_NxbbfAhUIjZAKHVYuABIQjRx6BAgBEAU&url=https%3A%2F%2Fpngimage.net%2Fdash-png-5%2F&psig=AOvVaw1mr31nvMdM94_Pczh72xG-&ust=1545674789000095",
          mining_type: MiningType.all.sample,
        },
      ]
      coins.each do |coin|
        sleep(1)
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastro dos tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando Tipos de Mineração ...") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"},
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private

  def show_spinner(msg_start, msg_end = "Concluído com Sucesso!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
