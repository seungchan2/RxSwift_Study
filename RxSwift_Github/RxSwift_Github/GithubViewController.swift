//
//  GithubViewController.swift
//  RxSwift_Github
//
//  Created by 김승찬 on 2022/05/06.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class GithubViewController: UIViewController {
    
    private let organization = "Apple"
    private let github = BehaviorSubject<[Github]>(value: [])
    // BehaviourSubject -> 초기값을 지정할 수 있음 하지만 현재 데이터 통신 전이기 때문에 따로 초기값을 세팅하지 않음
    private let disposeBag = DisposeBag()
    
    private lazy var tableView = UITableView().then {
        $0.register(GithubTableViewCell.self, forCellReuseIdentifier: "GithubTableViewCell")
        $0.rowHeight = 140
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRepositories(of: self.organization)
        title = organization + " Repositories"
        assignDelegation()
        view.addSubview(tableView)
        setConstraints()
        view.backgroundColor = .white
    }
    
    func fetchRepositories(of organization: String) {
        Observable.from([organization])
            .map { organization -> URL in
                return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
        
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [[String: Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String: Any]] else {
                    return []
                }
                return result
            }
            .filter { objects in
                return objects.count > 0
            }
            .map { objects in
                return objects.compactMap { dic -> Github? in
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let description = dic["description"] as? String,
                          let stargazersCount = dic["stargazers_count"] as? Int,
                          let language = dic["language"] as? String else {
                        return nil
                    }
                    
                    return Github(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
                }
            }
            .subscribe(onNext: {[weak self] newRepositories in
                self?.github.onNext(newRepositories)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func assignDelegation() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension GithubViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try github.value().count
        } catch {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GithubTableViewCell", for: indexPath) as? GithubTableViewCell else { return UITableViewCell() }
        
        var currentRepo: Github? {
            do {
                return try github.value()[indexPath.row]
            } catch {
                return nil
            }
        }
    
        cell.github = currentRepo
        
        return cell
    }
    
    
}

extension GithubViewController {
    func setConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
