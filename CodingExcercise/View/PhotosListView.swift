//
//  AppListView.swift
//  CodingExcercise
//
//  Created by Rahul R on 08/11/23.
//

import SwiftUI
import ComposableArchitecture

struct PhotosListView: View {
    let store: StoreOf<PhotoReducer>
    @State var presentModal: Bool = false


    func updatePhoto(id: Int, title: String){
        store.send(.updatePhotos(id, title))
    }
    var body: some View {
        NavigationView{
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack{
                    if(viewStore.isLoading){
                        ProgressView()
                    }
                    else{
                        List{
                            ForEach(viewStore.photos){ photo in
                                NavigationLink(destination: PhotoDetailsView(photo: photo, action: updatePhoto))
{
                                    VStack{
                                        Text(photo.title)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Photos")
                .onAppear(){
                    viewStore.send(.getPhotos)
                }
            }
        }
    }
}







#Preview {
        PhotosListView(
            store: Store(initialState: PhotoReducer.State()) {
                PhotoReducer()
            }
        )
 
}
