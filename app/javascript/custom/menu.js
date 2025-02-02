document.addEventListener("turbo:load", () => {
  let hamburguer = document.querySelector("#hamburguer")
  hamburguer.addEventListener("click", (event) => {
    event.preventDefault()
    event.stopPropagation()

    let menu = document.querySelector("#navbar-menu")
    menu.classList.toggle("collapse")
  })

  let account = document.querySelector("#account")
  account.addEventListener("click", (event) => {
    event.preventDefault()
    event.stopPropagation()

    let menu = document.querySelector("#dropdown-menu")
    menu.classList.toggle("active")
  })
})