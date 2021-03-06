//
//  DecorationCollectionViewFlowLayout.swift
//
//  Copyright © 2015 Sébastien MICHOY and contributors.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

import UIKit

class DecorationCollectionViewFlowLayout: UICollectionViewFlowLayout {
   
    // MARK: - Properties
    var decorationAttributes: [NSIndexPath: UICollectionViewLayoutAttributes]
    var sectionsWidthOrHeight: [NSIndexPath: CGFloat]
    
    // MARK: - Methods
    // MARK: Init / deinit
    override init() {
        self.decorationAttributes = [:]
        self.sectionsWidthOrHeight = [:]
        
        super.init()
        
        self.registerClass(ApplicationBackgroundCollectionReusableView.self, forDecorationViewOfKind: ApplicationBackgroundCollectionReusableView.kind())
    }

    required init(coder aDecoder: NSCoder) {
        self.decorationAttributes = [:]
        self.sectionsWidthOrHeight = [:]
        
        super.init(coder: aDecoder)
        
        self.registerClass(ApplicationBackgroundCollectionReusableView.self, forDecorationViewOfKind: ApplicationBackgroundCollectionReusableView.kind())
    }
    
    // MARK: Providing layout attributes
    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.decorationAttributes[indexPath]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributes = super.layoutAttributesForElementsInRect(rect)
        let numberOfSections = self.collectionView!.numberOfSections()
        var xOrYOffset = 0 as CGFloat
        
        for var sectionNumber = 0; sectionNumber < numberOfSections; sectionNumber++ {
            let indexPath = NSIndexPath(forRow: 0, inSection: sectionNumber)
            let sectionWidthOrHeight = self.sectionsWidthOrHeight[indexPath]!
            let decorationAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: ApplicationBackgroundCollectionReusableView.kind(), withIndexPath: indexPath)
            decorationAttribute.zIndex = -1
            
            if (self.scrollDirection == .Vertical) {
                decorationAttribute.frame = CGRect(x: 0, y: xOrYOffset, width: self.collectionViewContentSize().width, height: sectionWidthOrHeight)
            } else {
                decorationAttribute.frame = CGRect(x: xOrYOffset, y: 0, width: sectionWidthOrHeight, height: self.collectionViewContentSize().height)
            }
            
            xOrYOffset += sectionWidthOrHeight
            
            attributes?.append(decorationAttribute)
            self.decorationAttributes[indexPath] = decorationAttribute
        }
        
        return attributes
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        if self.collectionView == nil {
            return
        }
        
        if (self.scrollDirection == .Vertical) {
            let collectionViewWidthAvailableForCells = self.collectionViewContentSize().width - self.sectionInset.left - self.sectionInset.right
            let numberMaxOfCellsPerRow = floorf(Float((collectionViewWidthAvailableForCells + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing)))
            let numberOfSections = self.collectionView!.numberOfSections()
            
            for var sectionNumber = 0; sectionNumber < numberOfSections; sectionNumber++ {
                let numberOfCells = Float(self.collectionView!.numberOfItemsInSection(sectionNumber))
                let numberOfRows = CGFloat(ceilf(numberOfCells / numberMaxOfCellsPerRow))
                let sectionHeight = (numberOfRows * self.itemSize.height) + ((numberOfRows - 1) * self.minimumLineSpacing) + self.headerReferenceSize.height + self.footerReferenceSize.height + self.sectionInset.bottom + self.sectionInset.top
                
                self.sectionsWidthOrHeight[NSIndexPath(forRow: 0, inSection: sectionNumber)] = sectionHeight
            }
        } else {
            let collectionViewHeightAvailableForCells = self.collectionViewContentSize().height - self.sectionInset.top - self.sectionInset.bottom
            let numberMaxOfCellsPerColumn = floorf(Float((collectionViewHeightAvailableForCells + self.minimumInteritemSpacing) / (self.itemSize.height + self.minimumInteritemSpacing)))
            let numberOfSections = self.collectionView!.numberOfSections()
            
            for var sectionNumber = 0; sectionNumber < numberOfSections; sectionNumber++ {
                let numberOfCells = Float(self.collectionView!.numberOfItemsInSection(sectionNumber))
                let numberOfColumns = CGFloat(ceilf(numberOfCells / numberMaxOfCellsPerColumn))
                let sectionWidth = (numberOfColumns * self.itemSize.width) + ((numberOfColumns - 1) * self.minimumLineSpacing) + self.headerReferenceSize.width + self.footerReferenceSize.width + self.sectionInset.left + self.sectionInset.right
                
                self.sectionsWidthOrHeight[NSIndexPath(forRow: 0, inSection: sectionNumber)] = sectionWidth
            }
        }
    }
}
