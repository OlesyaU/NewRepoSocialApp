//
//  ProfileDotsController.swift
//  SocialApp
//
//  Created by Олеся on 02.07.2023.
//

import UIKit

class ProfileDotsController: UITableViewController {
    private let viewModel = ProfileDotsControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.backgroundColor
        view.cornerRadius(cornerRadius: 15)
      
    }

    func layout(frame: CGRect) {
        let originX = frame.origin.x
        let originY = frame.origin.y
        let size = CGSize(width: 300, height: 300)
        tableView.frame = .init(origin: .init(x: originX, y: originY), size: size)
    }

    // MARK: - Table view data source

    func prepareForRemove() {
        tableView.removeFromSuperview()
        view.removeFromSuperview()
        willMove(toParent: nil)
        removeFromParent()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profilePostDotsItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "identifier")
  cell.textLabel?.text = viewModel.profilePostDotsItems[indexPath.row]
        cell.contentView.backgroundColor = viewModel.backgroundColor
        cell.textLabel?.textColor = viewModel.profilePostDotsItemsColor
        cell.textLabel?.font = viewModel.profilePostDotsItemsFont
 return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
