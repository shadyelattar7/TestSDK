//
//  SettingsTableViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var cell: UITableViewCell!
    
    var presenter: SettingsPresenter?
    var ratingChecker = Bool()
    
    @IBOutlet weak var enableRatingLabel: UILabel!
    @IBOutlet weak var ratingSwitch: UISwitch!
    @IBOutlet weak var tipsCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        presenter?.addBarButtons(vc: self)
        setRatingSwitch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateNotification), name: NSNotification.Name("updateNotification"), object: nil)
    }
    
    @objc func handleUpdateNotification() {
        self.presenter?.getNumOfUnreadNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func localization() {
        self.navigationItem.title = "settings".localized
        cell.textLabel?.text = "changeMPin".localized
        enableRatingLabel.text = "Enable Rating".localized
        //tipsCell.textLabel?.text = NSLocalizedString("tips", comment: "tips")
        
    }

    func setRatingSwitch(){
        let ratingSwitchResponse = presenter?.setUpRatingSwitch()
        ratingSwitch.isOn =  (ratingSwitchResponse ?? false) ? true : false
    }
    
    func rateSwitchCheck(){
        ratingChecker =  ratingSwitch.isOn ? true : false
        presenter?.ratingSwitch(rating: ratingChecker)
    }
    @IBAction func menuClicked(_ sender: Any) {
        presenter?.menuClicked()
    }

    @IBAction func EnableRateAction(_ sender: Any) {
        rateSwitchCheck()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //for audi bank
        //return 2
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.presenter?.cellClicked(row: 0)
        } else {
            self.presenter?.cellClicked(row: 1)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
