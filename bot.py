#!/usr/bin/python
import random
from mastodon import Mastodon

Mastodon.create_app(
    'backupbot',
     api_base_url = 'https://your_pleoma_instance.com',
     to_file = 'backupbot_clientcred.secret'
)

mastodon = Mastodon(
    client_id = 'backupbot_clientcred.secret',
    api_base_url = 'https://your_pleoma_instance.com'
)

mastodon.log_in(
    'bot_account_username',
    'bot_account_password',
    to_file = 'backupbot_usercred.secret'
)

mastodon = Mastodon(
    access_token = 'backupbot_usercred.secret',
    api_base_url = 'https://your_pleoma_instance.com',
    feature_set = 'pleroma'
)

mastodon.status_post('your_post_content')
