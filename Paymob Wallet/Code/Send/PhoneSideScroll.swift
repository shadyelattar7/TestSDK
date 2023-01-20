//
//  PhoneSideScroll.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/26/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class PhoneSideScroll: UICollectionViewLayout {
    
    var collectionLayoutAttributes=[UICollectionViewLayoutAttributes]()
    var contentWidth:CGFloat?
    var contentHeight:CGFloat?
    
    //override func collectionViewContentSize() -> CGSize {
      //  return CGSize(width: contentWidth!, height: contentHeight!)
    //}
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth!, height: contentHeight!)
    }
    
    override func prepare() {
        self.contentHeight=90.0
        
        let cellsNo=self.collectionView?.numberOfItems(inSection: 0)
        let fcells=CGFloat(cellsNo!)
        
        self.contentWidth=(60*fcells)+(5*(fcells-1))
        
        
        for index in 0 ..< cellsNo! {
            
            let i=CGFloat(index+1)
            
            var xOffcet=(60*i)+(5*(i-1))
            
            xOffcet=xOffcet-60
            
            let myRect = CGRect(x: xOffcet,y: 0,width: 60.0,height: 90.0)
            
            let indexPath=IndexPath(item: index, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attr.frame=myRect
            collectionLayoutAttributes.append(attr)
            
        }
        
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var inSeen=[UICollectionViewLayoutAttributes]()
        
        for attr in collectionLayoutAttributes {
            if (rect.intersects(attr.frame)){
                inSeen.append(attr)
            }
            
        }
        return inSeen
    }
    
    
}

