import { Controller } from "stimulus"
import axios from "axios"

export default class extends Controller {
  static targets = [ "clapCount" ]

  addClap(event) {
    event.preventDefault()
    let target = this.clapCountTarget
    let slug = event.currentTarget.dataset.slug
    axios.post(`/stories/${slug}/clap`)
         .then(function (response) {
           let status = response.data.status
           switch (status) {
             case 'sign_in_first':
               alert('請先登入')
               break
             default:
               let clap_number = response.data.clap_number
               target.innerHTML = clap_number
           }
         })
         .catch(function (error) {
           console.log(error)
         })
  }
}
