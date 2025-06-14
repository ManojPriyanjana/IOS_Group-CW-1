//
//  editprofile.swift
//  University navigator
//
//  Created by Nadeemal 021 on 2025-06-13.
//
import SwiftUI

struct EditProfileView: View {
    @State private var name = "John Doe"
    @State private var email = "john.doe@university.edu"
    @State private var phone = "+1 (123) 456-7890"
    @State private var universityID = "U12345678"
    @State private var department = "Computer Science"
    
    let departments = [
        "Computer Science",
        "Mechanical Engineering",
        "Electrical Engineering",
        "Mathematics",
        "Physics"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Picture").bold()) {
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 80, height: 80)
                                .overlay(Text("JD").foregroundColor(.white).font(.title))
                            Image(systemName: "camera.fill")
                                .padding(6)
                                .background(Color.white)
                                .clipShape(Circle())
                                .offset(x: 8, y: 8)
                        }
                        Text("Student")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity)
                }

                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("University ID", text: .constant(universityID))
                        .disabled(true)
                    Picker("Department", selection: $department) {
                        ForEach(departments, id: \.self) { dept in
                            Text(dept)
                        }
                    }
                }

                Section {
                    HStack {
                        Spacer()
                        Button("Cancel", role: .cancel) {
                            // Handle cancel action
                        }
                        Spacer()
                        Button("Save Changes") {
                            // Handle save action
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Edit Profile")
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}

