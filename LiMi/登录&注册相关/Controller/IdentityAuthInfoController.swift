//
//  IdentityAuthInfoController.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/1/9.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import UIKit
import Moya
import SVProgressHUD
import ObjectMapper

class IdentityAuthInfoController: UITableViewController {
    @IBOutlet weak var school: UILabel!
    //学院
    @IBOutlet weak var academy: UILabel!
    @IBOutlet weak var grade: UILabel!
    
    var collegeModel:CollegeModel?
    var academyModel:AcademyModel?
    var gradeModel:GradeModel?
    
    //是否显示notice
    var isShowNotice = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "身份认证"
        self.tableView.estimatedRowHeight = 100
        self.tableView.estimatedSectionHeaderHeight = 100
        self.tableView.backgroundColor = UIColor.white
        
        let sumbitBtn = UIButton.init(type: .custom)
        let sumBitAttributeTitle = NSAttributedString.init(string: "提交", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.white])
        sumbitBtn.setAttributedTitle(sumBitAttributeTitle, for: .normal)
        sumbitBtn.sizeToFit()
        sumbitBtn.addTarget(self, action: #selector(dealSumbit), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: sumbitBtn)
        
        self.school.text = nil
        self.academy.text = nil
        self.grade.text = nil

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notNowBtn = UIButton.init(type: .custom)
        let notNowAttributeTitle = NSAttributedString.init(string: "暂不", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.white])
        notNowBtn.setAttributedTitle(notNowAttributeTitle, for: .normal)
        notNowBtn.sizeToFit()
        notNowBtn.addTarget(self, action: #selector(dealNotNow), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem?.customView = notNowBtn
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //提交
    @objc func dealSumbit(){
        if(self.collegeModel == nil){
            //显示错误警告
            SVProgressHUD.showErrorWith(msg: "请选择学校")
            return
        }
        if(self.academy == nil){
            //显示错误警告
            SVProgressHUD.showErrorWith(msg: "请选择学院")
            return
        }
        if(self.grade == nil){
            //显示错误警告
            SVProgressHUD.showErrorWith(msg: "请选择年级")
            return
        }
        SVProgressHUD.show(withStatus: nil)
        let moyaProvider = MoyaProvider<LiMiAPI>(manager: DefaultAlamofireManager.sharedManager)
        let registerForId = RegisterForID(college: self.collegeModel?.coid?.stringValue(), school: self.academyModel?.scid?.stringValue(), grade: self.gradeModel?.id?.stringValue())
        _ = moyaProvider.rx.request(.targetWith(target: registerForId)).subscribe(onSuccess: { (response) in
            let resultModel = Mapper<BaseModel>().map(jsonData: response.data)
            if resultModel?.commonInfoModel?.status == successState{
                let identityAuthStateController = IdentityAuthStateController()
                self.navigationController?.pushViewController(identityAuthStateController, animated: true)
            }
            SVProgressHUD.showErrorWith(model: resultModel)
        }, onError: { (error) in
            SVProgressHUD.showErrorWith(msg: error.localizedDescription)
        })
    }
    
    @objc func dealNotNow(){
        //返回主界面
        LoginServiceToMainController(loginRootController: self.navigationController)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3{return UITableViewAutomaticDimension}
        return 54
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isShowNotice && section == 0{
            let headerView = GET_XIB_VIEW(nibName: "IdentityAuthInfoHeaderView") as! IdentityAuthInfoHeaderView
            headerView.deleteBlock = {
                self.isShowNotice = false
                tableView.reloadData()
            }
            return headerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && self.isShowNotice{return UITableViewAutomaticDimension}
        return 0.001
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            self.toChooseCollege()
        }
        if indexPath.row == 1{
            self.toChooseAcademy()
        }
        if indexPath.row == 2{
            self.toChooseGrade()
        }
    }

}

extension IdentityAuthInfoController{
    func toChooseCollege(){
        let chooseSchoolController = ChooseSchoolController()
        chooseSchoolController.chooseBlock = {(collegeModel) in
            self.school.text = collegeModel?.name
            self.collegeModel = collegeModel
            self.academyModel = nil
            self.academy.text = nil
        }
        self.navigationController?.pushViewController(chooseSchoolController, animated: true)
    }
    
    func toChooseAcademy(){
        if let collegeId = self.collegeModel?.coid{
            let chooseAcademyController = ChooseAcademyController()
            chooseAcademyController.collegeId = collegeId
            chooseAcademyController.chooseAcademyBlock = {(academyModel) in
                self.academy.text = academyModel?.name
                self.academyModel = academyModel
            }
            self.navigationController?.pushViewController(chooseAcademyController, animated: true)
        }else{
            SVProgressHUD.showErrorWith(msg: "请先选择大学")
        }
    }
    
    func toChooseGrade(){
        let chooseGradeController = ChooseGradeController()
        chooseGradeController.chooseGradeBlock = {(gradeModel) in
            self.grade.text = gradeModel?.name
            self.gradeModel = gradeModel
        }
        self.navigationController?.pushViewController(chooseGradeController, animated: true)
    }
}
