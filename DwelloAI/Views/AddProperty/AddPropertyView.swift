//
//  AddPropertyView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 11.05.2026.
//

import SwiftUI
import PhotosUI

struct AddPropertyView: View {
    let listingType: ListingType
    var onClose: (() -> Void)? = nil

    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var userPropertyService: UserPropertyService
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var city = ""
    @State private var address = ""
    @State private var priceText = ""
    @State private var propertyType: PropertyType = .apartment
    @State private var roomsText = ""
    @State private var areaText = ""
    @State private var floorText = ""
    @State private var totalFloorsText = ""
    @State private var descriptionText = ""

    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []

    @State private var showValidationAlert = false
    @State private var showSuccessAlert = false

    private let accent = Color("AccentColor")

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    listingTypeBadge
                    photoPickerSection
                    basicInfoSection
                    propertyDetailsSection
                    descriptionSection
                    publishButton
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .navigationTitle(listingType == .sale ? "Add for Sale" : "Add for Rent")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onClose?() ?? dismiss() }
                        .foregroundStyle(accent)
                }
            }
            .alert("Fill in required fields", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please fill in title, city, address, and price.")
            }
            .alert("Published!", isPresented: $showSuccessAlert) {
                Button("Great!") { onClose?() ?? dismiss() }
            } message: {
                Text("Your listing has been published successfully.")
            }
        }
    }
}

private extension AddPropertyView {
    var listingTypeBadge: some View {
        HStack {
            Label(
                listingType == .sale ? "For Sale" : "For Rent",
                systemImage: listingType == .sale ? "tag.fill" : "key.fill"
            )
            .font(.custom("Poppins-SemiBold", size: 14))
            .foregroundStyle(accent)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(accent.opacity(0.1))
            .clipShape(Capsule())
            Spacer()
        }
    }

    var photoPickerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("Photos")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    PhotosPicker(
                        selection: $selectedPhotoItems,
                        maxSelectionCount: 8,
                        matching: .images
                    ) {
                        addPhotoButton
                    }
                    .onChange(of: selectedPhotoItems) { _, items in
                        loadImages(from: items)
                    }

                    ForEach(selectedImages.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Button {
                                selectedImages.remove(at: index)
                                if index < selectedPhotoItems.count {
                                    selectedPhotoItems.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .offset(x: 6, y: -6)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    var addPhotoButton: some View {
        VStack(spacing: 6) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(accent)
            Text("Add")
                .font(.custom("Poppins-Medium", size: 11))
                .foregroundStyle(accent)
        }
        .frame(width: 90, height: 90)
        .background(accent.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accent.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [5]))
        )
    }

    var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Basic Info")

            formField(placeholder: "Title (e.g. Modern 2BR Apartment)", text: $title)
            formField(placeholder: "City", text: $city)
            formField(placeholder: "Address", text: $address)
            formField(placeholder: "Price (₸)", text: $priceText, keyboardType: .numberPad)
        }
    }

    var propertyDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Property Details")

            VStack(alignment: .leading, spacing: 6) {
                Text("Type")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundStyle(.gray)

                HStack(spacing: 10) {
                    ForEach(PropertyType.allCases, id: \.self) { type in
                        Button {
                            propertyType = type
                        } label: {
                            Text(type.rawValue.capitalized)
                                .font(.custom("Poppins-Medium", size: 13))
                                .foregroundStyle(propertyType == type ? .white : accent)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(propertyType == type ? accent : accent.opacity(0.1))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            HStack(spacing: 12) {
                formField(placeholder: "Rooms", text: $roomsText, keyboardType: .numberPad)
                formField(placeholder: "Area m²", text: $areaText, keyboardType: .decimalPad)
            }

            HStack(spacing: 12) {
                formField(placeholder: "Floor", text: $floorText, keyboardType: .numberPad)
                formField(placeholder: "Total Floors", text: $totalFloorsText, keyboardType: .numberPad)
            }
        }
    }

    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Description")

            TextEditor(text: $descriptionText)
                .font(.custom("Poppins-Regular", size: 15))
                .frame(minHeight: 120)
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    Group {
                        if descriptionText.isEmpty {
                            Text("Describe your property...")
                                .font(.custom("Poppins-Regular", size: 15))
                                .foregroundStyle(Color(.placeholderText))
                                .padding(.horizontal, 16)
                                .padding(.top, 20)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .allowsHitTesting(false)
                        }
                    }
                )
        }
    }

    var publishButton: some View {
        Button {
            publish()
        } label: {
            Text("Publish Listing")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(accent)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }
}

private extension AddPropertyView {
    func sectionLabel(_ key: LocalizedStringKey) -> some View {
        Text(key)
            .font(.custom("Poppins-SemiBold", size: 16))
            .foregroundStyle(.black.opacity(0.85))
    }

    func formField(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(keyboardType)
            .font(.custom("Poppins-Regular", size: 15))
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    func loadImages(from items: [PhotosPickerItem]) {
        selectedImages = []
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                if case .success(let data) = result, let data, let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        selectedImages.append(img)
                    }
                }
            }
        }
    }

    func publish() {
        guard !title.isEmpty, !city.isEmpty, !address.isEmpty, !priceText.isEmpty else {
            showValidationAlert = true
            return
        }

        guard let ownerID = authViewModel.currentUser?.id else { return }

        let property = Property(
            id: Int(Date().timeIntervalSince1970 * 1000) % Int(Int32.max),
            title: title,
            city: city,
            address: address,
            price: Int(priceText) ?? 0,
            propertyType: propertyType,
            listingType: listingType,
            rooms: Int(roomsText) ?? 1,
            area: Double(areaText) ?? 0,
            floor: Int(floorText) ?? 1,
            totalFloors: Int(totalFloorsText) ?? 1,
            imageName: selectedImages.first.map { PhotoStorage.save($0) } ?? "placeholder",
            description: descriptionText,
            latitude: 0,
            longitude: 0,
            ownerID: ownerID
        )

        userPropertyService.add(property, for: ownerID)
        showSuccessAlert = true
    }
}
