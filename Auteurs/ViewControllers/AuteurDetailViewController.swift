/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class AuteurDetailViewController: UIViewController {
  var selectedAuteur: Auteur!
  let moreInfoText = "Tap For Details >"
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 300
    
    title = selectedAuteur.name
    self.tableView.contentInsetAdjustmentBehavior = .never
  }
}

extension AuteurDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedAuteur.films.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilmTableViewCell
    let film = selectedAuteur.films[indexPath.row]
    
    cell.filmTitleLabel.text = film.title
    cell.filmImageView.image = UIImage(named: film.poster)
    cell.filmTitleLabel.textColor = .white
    cell.filmTitleLabel.textAlignment = .center
    cell.moreInfoTextView.textColor = .red
    cell.selectionStyle = .none
    
    //Este código hará que una celda que se está reutilizando recuerde correctamente si estaba previamente en el estado expandido.
    
    cell.moreInfoTextView.text = film.isExpanded ? film.plot : moreInfoText
    cell.moreInfoTextView.textAlignment = film.isExpanded ? .left : .center
    cell.moreInfoTextView.textColor = film.isExpanded ?
        UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0) :
        .red

    //cell.textLabel?.text = film.plot
    
    return cell
  }
}

extension AuteurDetailViewController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    //1 Solicita tableViewuna referencia de la celda en el seleccionado indexPathy luego para obtener el Filmobjeto correspondiente.
    guard let cell = tableView.cellForRow(at: indexPath) as? FilmTableViewCell else{
      return
    }
    
    var film = selectedAuteur.films[indexPath.row]
    
    //2 Cambia el isExpandedestado del Filmobjeto y lo agrega de nuevo a la matriz, lo cual es necesario ya que las estructuras son tipos de valor.
    film.isExpanded = !film.isExpanded
    selectedAuteur.films[indexPath.row] = film
    
    //3 A continuación, modifica la vista de texto de la celda, dependiendo de si el trabajo está expandido. Si es así, configura la vista de texto para mostrar la propiedad de información de la película. También cambia la alineación del texto .lefty su color a gris claro. Si no se expande, vuelve a establecer el texto en "Tocar para obtener detalles>", la alineación en .centery el color en rojo.
    
    cell.moreInfoTextView.text = film.isExpanded ? film.plot : moreInfoText
    cell.moreInfoTextView.textAlignment = film.isExpanded ? .left : .center
    cell.moreInfoTextView.textColor = film.isExpanded ? UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0) : .red
    
    //4 La vista de tabla necesita actualizar las alturas de celda ahora. Llama beginUpdates()y endUpdates()forzará la vista de tabla para actualizar las alturas de una manera animada.
    tableView.beginUpdates()
    tableView.endUpdates()
    
    //5 Finalmente, le indica a la vista de tabla que desplace la fila seleccionada a la parte superior de la vista de tabla de una manera animada.
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)

  }
}

