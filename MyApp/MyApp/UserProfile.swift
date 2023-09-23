//
//  UserProfile.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import SwiftUI
import CoreData

struct UserProfile: View {
    @State private var imagePath: String? = nil
    @State private var showImagePicker = false
    @State private var imageUpdated = false // added state variable
    
    @State private var stateImage: Data = Data()
    @AppStorage("profileImage") private var profileImage: Data = Data()
    
    @AppStorage("firstName") var firstName = ""
    @State private var fieldFirstName: String = ""
    
    @AppStorage("lastName") var lastName = ""
    @State private var fieldLastName: String = ""
    
    @AppStorage("email") var email = ""
    @State private var fieldEmail: String = ""
    
        let defaults = UserDefaults.standard
 
    @State private var showSavedAlert = false

    private var imageURL: URL? {
        
        guard !stateImage.isEmpty else { return nil }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let imageURL = documentsDirectory.appendingPathComponent("stateImage.jpg")
         
         do {
             try stateImage.write(to: imageURL)
             return imageURL
         } catch {
             print("Error writing image data to disk: \(error.localizedDescription)")
             return nil
         }
    }

    var body: some View {
        VStack {
            HeaderView()
            VStack {
                if let imageURL = imageURL,
                   let imageData = try? Data(contentsOf: imageURL),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .id(imageUpdated)
                        .padding(.top, 18)
                        .padding(.bottom, 18)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.top, 18)
                        .padding(.bottom, 18)
                        .foregroundColor(mainColor)
                }
                Button(action: {
                    self.showImagePicker = true
                }) {
                    Text(imageURL != nil ? "Change Image" : "Select Image")
                        .padding(8)
                        .background(secondaryColor)
                        .foregroundColor(mainColor)
                        .cornerRadius(8)
                        .fontWeight(.medium)
                }
                Text("First Name")
                    .foregroundColor(.gray)
                    .padding(.top,15)
                TextField("John", text: $fieldFirstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Last Name")
                    .foregroundColor(.gray)
                TextField("Doe", text: $fieldLastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Email")
                    .foregroundColor(.gray)
                TextField("user@company.com", text: $fieldEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom,30)

                Button(action: {
                    if(!fieldFirstName.isEmpty) {
                        defaults.set(fieldFirstName, forKey: "firstName")
                    }
                    if(!fieldLastName.isEmpty) {
                        defaults.set(fieldLastName, forKey: "lastName")
                    }
                    if(!fieldEmail.isEmpty) {
                        defaults.set(fieldEmail, forKey: "email")
                    }
                    if(self.stateImage.count > 0) {
                        defaults.set(self.stateImage, forKey: "profileImage")
                    }
                    self.showSavedAlert = true
                }) {
                    Text("Save Changes")
                        .padding(8)
                        .background(mainColor)
                        .foregroundColor(secondaryColor)
                        .cornerRadius(8)
                        .fontWeight(.medium)
                }
               
               LogoutView(onLogout: onLogout)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    self.saveImageToState(image)
                    self.imageUpdated.toggle() // added toggle to update view
                }
            }
            .padding(.horizontal, 30)
            .background(mainBg)
            .padding(.bottom, 15)
            .onAppear {
               self.fieldFirstName = self.firstName
               self.fieldLastName = self.lastName
               self.fieldEmail = self.email
               self.stateImage = self.profileImage
            }
        }
        .alert(isPresented: $showSavedAlert) {
            Alert(title: Text("Changes Saved"), dismissButton: .default(Text("OK")))
        }
    }
    
    func onLogout() {
        // reset AppStorage values
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "profileImage")
        // reset state variables
        self.fieldFirstName = ""
        self.fieldLastName = ""
        self.fieldEmail = ""
        self.stateImage = Data()
    }

    private func saveImageToState(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        self.stateImage = data
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias UIImagePickerResult = (UIImage) -> Void

    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: UIImagePickerResult

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onImagePicked: UIImagePickerResult

        init(onImagePicked: @escaping UIImagePickerResult) {
            self.onImagePicked = onImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage
            if let image = selectedImage {
                onImagePicked(image)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

