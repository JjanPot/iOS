//
//  ProfileSetupRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


protocol ProfileSetupRepositoryProtocol {
    func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async throws
}