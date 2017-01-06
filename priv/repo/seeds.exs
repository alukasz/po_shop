# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PoShop.Repo.insert!(%PoShop.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PoShop.Repo
alias PoShop.Category
alias PoShop.Producent
alias PoShop.Product

spozywcze = Repo.insert! %Category{name: "Produkty spożywcze"}

nabial = Repo.insert! %Category{name: "Nabiał", parent_id: spozywcze.id}
mleko = Repo.insert! %Category{name: "Mleko", parent_id: nabial.id}
sery = Repo.insert! %Category{name: "Sery", parent_id: nabial.id}
jogurty = Repo.insert! %Category{name: "Jogurty", parent_id: nabial.id}


Repo.insert! %Category{name: "Produkty sypkie", parent_id: spozywcze.id}
Repo.insert! %Category{name: "Pieczywo", parent_id: spozywcze.id}
napoje = Repo.insert! %Category{name: "Napoje", parent_id: spozywcze.id}
Repo.insert! %Category{name: "Owoce i warzywa", parent_id: spozywcze.id}

Repo.insert! %Category{name: "Wody", parent_id: napoje.id}
Repo.insert! %Category{name: "Soki", parent_id: napoje.id}
Repo.insert! %Category{name: "Napoje słodzone", parent_id: napoje.id}
Repo.insert! %Category{name: "Alkohol", parent_id: napoje.id}


laciate = Repo.insert! %Producent{name: "Łaciate"}
dolina = Repo.insert! %Producent{name: "Mleczna Dolina"}
pastwisko = Repo.insert! %Producent{name: "Pastwisko"}

desc = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In et faucibus nulla. Ut augue arcu, pharetra ac magna nec, pellentesque auctor turpis. Sed auctor diam urna, in scelerisque urna eleifend convallis. In hac habitasse platea dictumst. Curabitur interdum accumsan nisl sed semper. Nulla sed lectus risus. Nam facilisis dolor libero, sit amet vulputate est tempor quis. Pellentesque id orci vel justo tincidunt volutpat."

Repo.insert! %Product{name: "Ser Gouda", description: desc, price: 12.99, stock: 5,
  producent_id: laciate.id, category_id: sery.id}
Repo.insert! %Product{name: "Ser topiony", description: desc, price: 3.99, stock: 9,
  producent_id: dolina.id, category_id: sery.id}
Repo.insert! %Product{name: "Ser wędzony", description: desc, price: 25.99, stock: 2,
  producent_id: pastwisko.id, category_id: sery.id}

Repo.insert! %Product{name: "Mleko 3.2%", description: desc, price: 3.39, stock: 5,
  producent_id: laciate.id, category_id: mleko.id}
Repo.insert! %Product{name: "Mleko 2%", description: desc, price: 2.99, stock: 9,
  producent_id: laciate.id, category_id: mleko.id}
Repo.insert! %Product{name: "Napóuj UHT 0.5%", description: desc, price: 1.99, stock: 8,
  producent_id: dolina.id, category_id: mleko.id}
Repo.insert! %Product{name: "Woda nie mleko ", description: desc, price: 1.49, stock: 22,
  producent_id: dolina.id, category_id: mleko.id}
Repo.insert! %Product{name: "Super mleko", description: desc, price: 4.49, stock: 1,
  producent_id: pastwisko.id, category_id: mleko.id}

Repo.insert! %Product{name: "Jogurt truskawkowy", description: desc, price: 1.69, stock: 12,
  producent_id: pastwisko.id, category_id: jogurty.id}
