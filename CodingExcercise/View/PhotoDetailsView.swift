//
//  PhotoDetailsView.swift
//  CodingExcercise
//
//  Created by Rahul R on 12/11/23.
//

import SwiftUI

struct PhotoDetailsView: View{
    
    @State var photo: Photo
    @State private var title: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    
    let action: (_ id: Int, _ title: String) -> Void
    
    var body: some View{
        
        VStack{
            TextField("title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 5)
                
            AsyncImage(url: URL(string: photo.url)){ image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 200)
            }
            placeholder: {
                ProgressView()
                    .frame(width: 160, height: 200)
            }
        }
        
        .padding(.horizontal, 10)
        .toolbar{
            ToolbarItem{
                Button("Save"){
                    action(photo.id, title)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear{
            self.title  = photo.title
        }
    }
}


