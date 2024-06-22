//
//  NXCircleProgress.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import SwiftUI

struct CircleProgressModel {
    var color: UInt64
    var percent: Double
}

struct NXCircleProgressView: View {
    
    let progresses: [CircleProgressModel]
    let strokeWidth: Double = 10
    let totalDays: Double
    let viewDetail: () -> Void
    
    init(
        progresses: [CircleProgressModel],
        totalDays: Double,
        viewDetail: @escaping () -> Void
    ) {
        self.progresses = progresses
        self.totalDays = totalDays
        self.viewDetail = viewDetail
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: strokeWidth)
                .foregroundColor(Color.theme.whiteGray)
            
            ForEach(progresses, id: \.color) { progress in
                NXCircleProgress(progress: progress.percent)
                    .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                    .foregroundColor(Color(uiColor: UIColor(fromUInt64: progress.color)))
            }
            
            VStack {
                Text("Total Left")
                    .fontWeight(.light)
                
                Text(totalDays.toDays())
                    .font(.largeTitle)
                    .padding(.top, 2)
                
                Button {
                    viewDetail()
                } label: {
                    Text("View Detail")
                        .font(.footnote)
                }
                .buttonStyle(.plain)
                .padding(.top)
            }
        }
        .frame(width: 250, height: 250)
    }
}

private struct NXCircleProgress: Shape {
    
    let progress: Double
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height/2,
                startAngle: Angle(degrees: -90),
                endAngle: Angle(degrees: progress - 90),
                clockwise: false
            )
        }
    }
}

struct NXCircleProgress_Previews: PreviewProvider {
    static var previews: some View {
        NXCircleProgressView(
            progresses: [
                CircleProgressModel(color: 4284856129, percent: 200)
            ],
            totalDays: 17.5
        ) {
            
        }
    }
}
