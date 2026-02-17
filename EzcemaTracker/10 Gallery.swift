//
//  10 Gallery.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 10/2/26.
//

import PhotosUI
import SwiftUI
import UIKit
import SwiftData

struct GalleryView: View {
    
    @State private var path = NavigationPath()
    @AppStorage("island") var selectedIsland: Bool = false
    @State private var showOnboarding = false
    
    @State private var selectedImage: UIImage?
    @State private var showingCamera = false
    @State private var selectedPhotos: [PhotosPickerItem] = []
    
    @Environment(\.modelContext) var context
    @Query var images: [Photo]
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()

                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(images, id: \.self) { photo in
                            if let uiImage = UIImage(data: photo.data) {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 190, height: 150)
                                        .cornerRadius(5)
                                    Button(action: {
                                        context.delete(photo)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundStyle(.red)
                                            .font(.system(size: 20))
                                            .padding(8)
                                    }
                                    
                                }
                            }
                        }
                    }
                    .padding(.top, 60)
                    
                }
                .navigationTitle("Progress Gallery")
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button("Add", systemImage: "camera") {
                                showingCamera = true
                            }
                            
                            PhotosPicker(selection: $selectedPhotos, matching: .images, photoLibrary: .shared()) {
                                Image(systemName: "photo")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraView(image: $selectedImage)
            }
            .onChange(of: selectedImage) {
                if let selectedImage, let data = selectedImage.pngData() {
                    savePics(data: data)
                }
            }
            .onChange(of: selectedPhotos) { _, newItems in
                Task {
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            savePics(data: data)
                        }
                    }
                }
            }
        }
    }
    
    func savePics(data: Data) {
        let photo = Photo(data: data)
        context.insert(photo)
    }
}
    

#Preview {
    GalleryView()
}
