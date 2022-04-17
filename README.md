# MovieSearchApp

네이버 영화검색 API를 활용한 iOS 어플리케이션.

## Description
- 최소 타겟 : iOS 14.0
- Portrait 모드만 지원
- MVVM - Input/Output 패턴 적용
- Storyboard를 활용하지 않고 코드로만 UI 구성
- [개발 공수](https://maze-mozzarella-6e5.notion.site/bfa4e5ece7df44108a19e8f1a63bcbc1)

## Getting Started

### Skill

    Swift, RxSwift, RxCocoa
    MVVM + Input/Output
    UIKit, AutoLayout
    Alamofire, SnapKit, Kingfisher, Toast
    Realm

### Issue

#### UIView를 customView로 적용한 UIBarButtonItem 타겟과 액션 미적용 이슈
* UIBarButtonItem에 UIView를 커스텀뷰로 적용해서 초기화해준 뒤, 타겟과 액션을 추가했지만 작동하지 않는 이슈가 존재했다.
* [확인 결과](https://stackoverflow.com/questions/2796438/uibarbuttonitem-target-action-not-working), UIBarButtonItem은 UIView를 커스텀뷰로 적용했을 때 타겟과 액션을 허용하지 않는다고 한다.
* UIButton에

### Reflection

#### 1. Realm vs Userdefaults
* 즐겨찾기 목록 유지를 위해 Realm 데이터베이스와 Userdefaults를 두고 고민이 필요했다. 처음에는 간단하게 해보려고 Userdefaults를 써볼까 생각했지만 데이터가 담아야할 정보의 양이 많았고 즐겨찾기 추가/제거 로직 때문에 수시로 데이터를 호출하고 변화시켜줘야했다. 따라서, 앱의 볼륨은 다소 커질 수 있지만 Realm 데이터베이스를 사용하는게 맞다고 판단했다. 

#### 2. 즐겨찾기 추가/제거 로직
* 제일 시간이 많이 소요됐던 로직인데, 즐겨찾기 추가/제거 로직이 모든 뷰에서 이뤄져야 했고 어떤 하나의 뷰에서 일어난 즐겨찾기 추가/제거가 다른 모든 뷰에도 영향을 줘야 했다.
  + (1) 즐겨찾기뷰에 있는 데이터들을 만약 검색뷰에서 해당 데이터들을 검색한다면 즐겨찾기 버튼에 색깔이 들어와 있어야함.
  + (2) 검색뷰에서 즐겨찾기뷰에 있는 데이터를 즐겨찾기 제거하면 즐겨찾기 뷰에서도 제가가 되어야함.
  + (3) 어떤 데이터의 디테일뷰에서 즐겨찾기를 추가하고 dismiss했을 때, 검색뷰에서 해당 데이터의 즐겨찾기 버튼 색깔이 들어와 있어야함.
  + (4) 즐겨찾기뷰에서 디테일뷰로 넘어갔을 때, 디테일 뷰에서 즐겨찾기를 해제하고 dismiss하면 즐겨찾기 뷰에서 해당 데이터가 삭제되어야함.
  + (5) 검색뷰에서 어떤 데이터를 즐겨찾기 추가하고 다시 해당 데이터를 검색했을 때, 즐겨찾기 버튼에 색깔이 들어와있어야 함.
* 위의 모든 고려사항을 간단하게 해결할 수 있는 방법이 뭘까 고민하다가 내린 해결책은 큰 바운더리에서 접근했을 때 1차적으로 검색 데이터를 호출하기 전에 즐겨찾기 목록에 있는 데이터인지 filter 해보는 것이었다. 일단 1차적으로 필터링하는 로직을 구현하고 난 뒤에, 이를 기반으로 해서 다른 고려사항들을 해결해나갈 수 있었다.

#### 3. Input/Output 패턴 적용
* MVVM의 가장 큰 단점은 사람마다 구현 방식이 조금씩 다르다는 것이다. 이러한 점은 결국 다른 사람이 내 코드를 봤을때, 가독성에 좋지 않은 영향을 미칠 수 있다고 생각했다. 따라서 정형화된 패턴을 통한 통일성 있는 코드 작성을 위해 프로토콜을 활용한 Input/Output 패턴을 적용했다.

#### 4. CustomView 활용으로 코드 재사용성 강화
* 똑같은 형태의 영화 데이터 뷰가 모든 뷰에서 사용되어야 했다. 커스텀 뷰로 만들어 줌으로써, 재사용성을 강화했다.

*****

## ScreenShot

