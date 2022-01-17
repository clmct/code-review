//
//  PeopleCollectionViewLayout.swift
//  ITindr
//
//  Created by Эдуард Логинов on 30.11.2021.
//

import UIKit

class PeopleCollectionViewLayout: UICollectionViewFlowLayout {
    
    // MARK: Properties
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    var cellAspectRatio = 1.346
    var centerColumnTopOffset: CGFloat = 0
    
    private let numberOfColumns = 3
    
    private var attributesCache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // MARK: Public Overrided Methods
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        var column = 0
        let columnWidth = (contentWidth - minimumInteritemSpacing * CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns)
        let xOffset: [CGFloat] = (0..<numberOfColumns).map { columnNumber in
            CGFloat(columnNumber) * columnWidth + minimumInteritemSpacing * CGFloat(columnNumber)
        }
        var yOffset: [CGFloat] = [0, centerColumnTopOffset, 0]
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let cellHeight: CGFloat = columnWidth * cellAspectRatio
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: cellHeight)
          
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            attributesCache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY + minimumLineSpacing)
            yOffset[column] += cellHeight + minimumLineSpacing

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesCache.filter { attributes in
            return attributes.frame.intersects(rect)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesCache[indexPath.item]
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        attributesCache = []
        contentHeight = 0
    }
}
