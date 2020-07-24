//
//  ViewController.swift
//  MySwiftNews
//
//  Created by Sailee Pereira on 2020-07-21.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var articleListTableView: UITableView!
    
    //MARK:- Properties
    private(set) var applicationServices : ApplicationServices = (UIApplication.shared.delegate as! AppDelegate).applicationServices
    private var articleList = [ArticleModel]() {
        didSet {
            articleListTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleListTableView.delegate = self
        articleListTableView.dataSource = self
        fetchArticles()
    }
    
    //method for updating the navigation bar
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Swift News"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .red
        let refreshButton = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshTapped))
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    @objc func refreshTapped() {
        fetchArticles()
    }
    
    //method responsible for triggering the fetch Call and updating the view based on response
    private func fetchArticles() {
        showActivityIndicator(onView: self.view)
        applicationServices.getArticleService()?.getArticles(onCompletion: { [unowned self] errorResponse, response in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                if let error = errorResponse { //handle error here
                    self.articleList = []
                    self.articleListTableView.setEmptyView(message: error.message)
                } else {
                    guard let articleResponse = response else { return }
                    self.articleListTableView.restore()
                    self.articleList = articleResponse
                }
            }
        })
    }
}

//MARK:- TableView Delegate Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleListTableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        cell.configureCell(with: articleList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let articleView = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ArticleViewController") as? ArticleViewController {
            articleView.articleModel = articleList[indexPath.row]
            navigationController?.pushViewController(articleView, animated: true)
        }
    }
}
