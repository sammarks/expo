package abi41_0_0.expo.modules.notifications.notifications.channels;

import android.content.Context;

import abi41_0_0.expo.modules.notifications.notifications.channels.managers.AndroidXNotificationsChannelGroupManager;
import abi41_0_0.expo.modules.notifications.notifications.channels.managers.AndroidXNotificationsChannelManager;
import abi41_0_0.expo.modules.notifications.notifications.channels.managers.NotificationsChannelGroupManager;
import abi41_0_0.expo.modules.notifications.notifications.channels.managers.NotificationsChannelManager;
import abi41_0_0.expo.modules.notifications.notifications.channels.serializers.ExpoNotificationsChannelGroupSerializer;
import abi41_0_0.expo.modules.notifications.notifications.channels.serializers.ExpoNotificationsChannelSerializer;
import abi41_0_0.expo.modules.notifications.notifications.channels.serializers.NotificationsChannelGroupSerializer;
import abi41_0_0.expo.modules.notifications.notifications.channels.serializers.NotificationsChannelSerializer;

public class AndroidXNotificationsChannelsProvider extends AbstractNotificationsChannelsProvider {
  public AndroidXNotificationsChannelsProvider(Context context) {
    super(context);
  }

  @Override
  protected NotificationsChannelManager createChannelManager() {
    return new AndroidXNotificationsChannelManager(mContext, getGroupManager());
  }

  @Override
  protected NotificationsChannelGroupManager createChannelGroupManager() {
    return new AndroidXNotificationsChannelGroupManager(mContext);
  }

  @Override
  protected NotificationsChannelSerializer createChannelSerializer() {
    return new ExpoNotificationsChannelSerializer();
  }

  @Override
  protected NotificationsChannelGroupSerializer createChannelGroupSerializer() {
    return new ExpoNotificationsChannelGroupSerializer(getChannelSerializer());
  }
}
