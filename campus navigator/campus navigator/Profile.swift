//
//  Profile.swift
//  University navigator
//
//  Created by Nadeemal 021 on 2025-06-13.
//
import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            // Avatar with initials and edit icon
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text("JD")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                    )
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 16))
                    )
                    .offset(x: 5, y: 5)
            }
            
            // Name and Role
            Text("John Doe")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Student")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(12)
            
            Divider()
                .padding(.vertical, 10)
            
            // Personal Details Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text("Personal Details")
                        .font(.headline)
                }
                
                ProfileRow(icon: "envelope.fill", label: "Email", value: "john.doe@university.edu")
                ProfileRow(icon: "phone.fill", label: "Phone", value: "+1 (123) 456-7890")
                ProfileRow(icon: "briefcase.fill", label: "University ID", value: "U12345678")
                ProfileRow(icon: "building.2.fill", label: "Department", value: "Computer Science")
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Edit Profile Button
            Button(action: {
                // Edit action
            }) {
                Text("Edit Profile")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding()
    }
}

struct ProfileRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text("\(label):")
                .fontWeight(.semibold)
            + Text(" \(value)")
        }
        .font(.subheadline)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

