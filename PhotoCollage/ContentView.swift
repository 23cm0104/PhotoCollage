//
//  ContentView.swift
//  PhotoCollage
//
//  Created by cmStudent on 2024/06/28.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var textColor = Color.blue
    @State var textEachColor: [Color] = []
    @State var words: String = ""
    @State var textArray: [String] = []
    
    @State var animationSwap: [Bool] = [false]
    
    @State var stampScale: [CGFloat] = []
    @State var textScale: [CGFloat] = []
    @State var stampOffsets: [CGSize] = []
    @State var textOffsets: [CGSize] = []
    @State var stampRotation: [Angle] = []
    @State var textRotation: [Angle] = []
    
    @State var stampLastScaleValue: [CGFloat] = []
    @State var textLastScaleValue: [CGFloat] = []
    @State var stampLastOffsetValue: [CGSize] = []
    @State var textLastOffsetValue: [CGSize] = []
    
    @State var stamps: [String] = []
    @State var subStamps: [String] = []
    @State var isShowingStampSet = false
    @State var selectedStamp: String?
    @State var selectedSubStamp: String?
    
    @State var isShowingDialog = false
    @State var isShowingCameraView = false
    @State var isShowingImagePickerView = false
    @State var selectedImage: UIImage?
    
    @State var scale: CGFloat = 1.0
    @State var offset: CGSize = .zero
    @State var rotation: Angle = .zero
    
    @State var lastScaleValue: CGFloat = 1.0
    @State var lastOffsetValue: CGSize = .zero
    
    var rotationGesture: some Gesture {
        RotationGesture()
            .onChanged{ angle in
                rotation = angle
            }
            .onEnded { angle in
                rotation = angle
            }
    }
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScaleValue
                lastScaleValue = value
                scale = value
                scale *= delta
            }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = CGSize(width: value.translation.width + lastOffsetValue.width, height: value.translation.height + lastOffsetValue.height)
            }
            .onEnded { _ in
                lastOffsetValue = offset
            }
    }
    
    var body: some View {
        
        let compositeIamge = ZStack {
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .rotationEffect(rotation)
                    .offset(offset)
                    .simultaneousGesture(rotationGesture)
                    .simultaneousGesture(magnificationGesture)
                    .simultaneousGesture(dragGesture)
            }
            
            if !stamps.isEmpty {
                ForEach(stamps.indices, id: \.self) {index in
                    Text(animationSwap[index] ? subStamps[index] : stamps[index] )
                        .font(.system(size: 100))
                        .offset(stampOffsets[index])
                        .scaleEffect(stampScale[index])
                        .rotationEffect(stampRotation[index])
                        .onTapGesture {animationSwap[index].toggle()}
                        .simultaneousGesture(
                            DragGesture()
                                .onChanged { value in
                                    stampOffsets[index] = CGSize(width: value.translation.width + stampLastOffsetValue[index].width, height: value.translation.height + stampLastOffsetValue[index].height)
                                }
                                .onEnded { _ in
                                    stampLastOffsetValue[index] = stampOffsets[index]
                                }
                        )
                        .simultaneousGesture(
                            RotationGesture()
                                .onChanged{ angle in
                                    stampRotation[index] = angle
                                }
                                .onEnded { angle in
                                    stampRotation[index] = angle
                                }
                        )
                        .simultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let delta = value / stampLastScaleValue[index]
                                    stampLastScaleValue[index] = value
                                    stampScale[index] *= delta
                                }
                        )
                }
            }
            if !textArray.isEmpty {
                ForEach(textArray.indices, id: \.self) { index in
                    Text(textArray[index])
                        .font(.largeTitle)
                        .offset(textOffsets[index])
                        .foregroundColor(textEachColor[index])
                        .scaleEffect(textScale[index])
                        .rotationEffect(textRotation[index])
                        .simultaneousGesture(
                            DragGesture()
                                .onChanged { value in
                                    textOffsets[index] = CGSize(width: value.translation.width + textLastOffsetValue[index].width, height: value.translation.height + textLastOffsetValue[index].height)
                                }
                                .onEnded { _ in
                                    textLastOffsetValue[index] = textOffsets[index]
                                }
                        )
                        .simultaneousGesture(
                            RotationGesture()
                                .onChanged{ angle in
                                    textRotation[index] = angle
                                }
                                .onEnded { angle in
                                    textRotation[index] = angle
                                }
                        )
                        .simultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let delta = value / textLastScaleValue[index]
                                    textLastScaleValue[index] = value
                                    textScale[index] *= delta
                                }
                        )
                }
            }
        }.frame(width: 400, height: 600)
        
        VStack {
            Spacer()
            compositeIamge
            Spacer()
        }
        .safeAreaInset(edge: .bottom, content: {
            VStack {
                HStack {
                    TextField("テキスト", text: $words).border(.gray).font(.title)
                        .padding(.trailing)
                    
                    Button(action: {addText()}, label: {
                        Text("Add Text")
                    })
                }.padding(.bottom)
                .buttonStyle(.borderedProminent).buttonBorderShape(.roundedRectangle).tint(.blue)
                ColorPicker("テキスト色", selection: $textColor)
                .padding(.bottom)
                HStack {
                    Button(action: {
                        isShowingDialog = true
                    }, label: { Text("背景") })
                    .confirmationDialog("背景", isPresented: $isShowingDialog, titleVisibility: .visible, actions: {
                        Button(action: { isShowingCameraView = true }, label: { Text("カメラから") })
                        Button(action: { isShowingImagePickerView = true }, label: { Text("写真から") })
                        
                    })
                    .sheet(isPresented: $isShowingCameraView, content: {
                        CameraView(isShowingCameraView: $isShowingCameraView, captureImage: $selectedImage)
                    })
                    .sheet(isPresented: $isShowingImagePickerView, content: {
                        ImagePicker(selectedImage: $selectedImage)
                    })
                    .padding(.trailing)
                    Button(action: { isShowingStampSet = true }, label: { Text("スタンプ") }).sheet(isPresented: $isShowingStampSet, onDismiss: addStamp, content: {
                        StampView(stamp: $selectedStamp, subStamp: $selectedSubStamp ).presentationDetents([.height(200)])
                    })
                    .padding(.trailing)
                    Button(action: {
                        let renderer = ImageRenderer(content: compositeIamge)
                        if let image = renderer.uiImage, let pngData = image.pngData(), let png = UIImage(data: pngData) {
                            UIImageWriteToSavedPhotosAlbum(png, nil, nil, nil)
                        }
                    }, label: { Text("保存") })
                }.buttonStyle(.borderedProminent).buttonBorderShape(.roundedRectangle).tint(.blue)
            }
            
        }).padding()
    }
    private func addText() {
        textArray.append(words)
        textOffsets.append(.zero)
        textLastOffsetValue.append(.zero)
        textScale.append(1.0)
        textLastScaleValue.append(1.0)
        textRotation.append(.zero)
        textEachColor.append(textColor)
    }
    
    private func addStamp() {
        if let selectedStamp {
            stamps.append(selectedStamp)
            subStamps.append(selectedSubStamp ?? "")
            stampOffsets.append(.zero)
            stampRotation.append(.zero)
            stampScale.append(1.0)
            stampLastScaleValue.append(1.0)
            stampLastOffsetValue.append(.zero)
            animationSwap.append(false)
        }
    }
    
}

#Preview {
    ContentView()
}
