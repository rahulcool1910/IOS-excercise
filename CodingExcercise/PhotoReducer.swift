//
//  PhotoReducer.swift
//  CodingExcercise
//
//  Created by Rahul R on 08/11/23.
//

import ComposableArchitecture
import SwiftUI

struct Photo: Codable, Identifiable, Equatable {
    let albumId: Int
    let id: Int
    var title: String
    let url: String
    let thumbnailUrl: String
}

struct PhotoReducer: Reducer {
    struct State : Equatable {
        
        var photos: [Photo]
        var isLoading: Bool
        init() {
            self.photos = [];
            self.isLoading = false;
        }
    }
    
    enum Action {
        case getPhotos
        case addPhotoResponse([Photo])
        case updatePhotos(Int, String)
        case setLoadingState(Bool)

        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .getPhotos:
            if(!state.photos.isEmpty){
                return .none
            }
            print("called")
            let url = "https://jsonplaceholder.typicode.com/photos"
            return .run { send in
                do {
                    await send(.setLoadingState(true))
                    let (data, response) = try await URLSession.shared
                        .data(from: URL(string: url)!)
                    
                    
                    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                        
                        return
                    }

                    
                    guard let photosResponse = try? JSONDecoder().decode([Photo].self, from: data) else {
                        
                        
                        return
                    }
                    await send(.addPhotoResponse(photosResponse))
                    await send(.setLoadingState(false))
                }
                catch {
                    await send(.setLoadingState(false))
                }
                
                
            }
        case let .setLoadingState(loadingState):
            state.isLoading = loadingState
            return .none
            
        case let .addPhotoResponse(photos):
            state.photos = photos;
            return .none

        case let .updatePhotos(id, title):
            if let index = state.photos.firstIndex(where : {$0.id ==  id}){
                var refPhotos = state.photos;
                refPhotos[index].title = title;
                state.photos = refPhotos;
                print(state.photos[index]);
            }
            return .none
        }
    }
}

