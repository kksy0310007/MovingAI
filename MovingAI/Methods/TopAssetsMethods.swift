//
//  TopAssetsMethods.swift
//  MovingAI
//
//  Created by soyoung on 12/26/24.
//


import UIKit

class TopAssetsMethods {
    
    static let shared = TopAssetsMethods()
    
    // 전체 장비
    var allSitesAssets: [AssetData] = []
    
    private var selectedAsset: AssetData? = nil
    
    var onlineAssetsList: [AssetData] = []
    
    
    func getAllSitesAssetsList() -> [AssetData] {
        return allSitesAssets
    }
    
    func setAllSitesAssetsList(_ list: [AssetData]) {
        allSitesAssets = list
    }
    
    private init() {
        
    }
    
    func removeAll() {
        allSitesAssets.removeAll()
        selectedAsset = nil
        onlineAssetsList.removeAll()
    }
    
}
