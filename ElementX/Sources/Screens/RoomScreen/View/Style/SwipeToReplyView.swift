//
// Copyright 2023 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

struct SwipeToReplyView: View {
    let timelineItem: RoomTimelineItemProtocol
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "arrowshape.turn.up.left")
                .foregroundColor(.compound.iconPrimary)
            if let messageTimelineItem = timelineItem as? EventBasedMessageTimelineItemProtocol,
               messageTimelineItem.isThreaded {
                Text(L10n.actionReplyInThread)
                    .font(.compound.bodyXS)
                    .foregroundColor(.compound.textPrimary)
            }
        }
        .accessibilityHidden(true)
    }
}

struct SwipeToReplyView_Previews: PreviewProvider {
    static let timelineItem = TextRoomTimelineItem(id: .init(timelineID: ""),
                                                   timestamp: "",
                                                   isOutgoing: true,
                                                   isEditable: true,
                                                   isThreaded: false, sender: .init(id: ""),
                                                   content: .init(body: ""))
    static let threadedTimelineItem = TextRoomTimelineItem(id: .init(timelineID: ""),
                                                           timestamp: "",
                                                           isOutgoing: true,
                                                           isEditable: true,
                                                           isThreaded: true,
                                                           sender: .init(id: ""),
                                                           content: .init(body: ""))
    
    static var previews: some View {
        SwipeToReplyView(timelineItem: timelineItem)
        SwipeToReplyView(timelineItem: threadedTimelineItem)
    }
}