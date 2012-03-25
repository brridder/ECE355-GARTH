package com.ece355.garth;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.alexd.jsonrpc.JSONRPCClient;
import org.alexd.jsonrpc.JSONRPCException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.app.ListActivity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.SimpleAdapter;

public class GARTHActivity extends ListActivity {

	private static String RPC_METHOD_GET_EVENTS = "get_events";

	private static final int DOOR_SENSOR_EVENT = 1;
	private static final int WINDOW_SENSOR_EVENT = 2;
	private static final int FLOOD_SENSOR_EVENT = 3;
	private static final int TEMP_SENSOR_EVENT = 4;
	private static final int ALARM_EVENT = 5;
	private static final int KEYPAD_EVENT = 6;
	private static final int NFC_EVENT = 7;
	private static final int MOTION_SENSOR_EVENT = 8;

	private static final int CRITICAL_ALARM = 1;
	private static final int MAJOR_ALARM = 2;
	private static final int MINOR_ALARM = 3;

	private static final SimpleDateFormat sDateFormat = new SimpleDateFormat(
			"h:mm a", Locale.CANADA);

	public void refreshData() {
		try {
			SimpleAdapter adapter = new SimpleAdapter(this, getEvents(),
					R.layout.list_item, new String[] { "timestamp",
							"main_text", "sub_text", "image_resource" },
					new int[] { R.id.event_timestamp, R.id.event_title,
							R.id.event_subtitle, R.id.event_image });
			setListAdapter(adapter);
		} catch (JSONRPCException e) {
			Log.e(GARTHActivity.class.getName(), "JSON RPC Error", e);
		} catch (JSONException e) {
			Log.e(GARTHActivity.class.getName(), "JSON Error", e);
		}
	}

	public List<? extends Map<String, ?>> getEvents() throws JSONRPCException,
			JSONException {
		SharedPreferences settings = PreferenceManager
				.getDefaultSharedPreferences(this);
		String url = settings.getString("url_preference",
				"http://localhost:3000");

		JSONRPCClient rpcClient = JSONRPCClient.create(url);
		rpcClient.setConnectionTimeout(2000);
		rpcClient.setSoTimeout(2000);

		Log.d(GARTHActivity.class.getName(), "Calling " + url);
		String events_json = rpcClient.callString(RPC_METHOD_GET_EVENTS);
		JSONArray events = (JSONArray) new JSONTokener(events_json).nextValue();

		Log.d(GARTHActivity.class.getName(), events.toString());

		ArrayList<HashMap<String, Object>> event_list = new ArrayList<HashMap<String, Object>>(
				events.length());

		for (int i = 0; i < events.length(); i++) {
			String main_text;

			JSONObject event = events.getJSONObject(i);
			HashMap<String, Object> event_map = new HashMap<String, Object>(
					event.length());

			//
			// Get timestamp
			//

			int timestamp = event.getInt("timestamp");
			event_map.put("timestamp",
					sDateFormat.format(new Date(timestamp * 1000l)));

			//
			// Parse event-specific fields
			//

			String sub_text = "";
			int event_type = event.getInt("event_type");
			switch (event_type) {
			case DOOR_SENSOR_EVENT: {
				int door_id = event.getInt("door_id");

				sub_text = "Door " + door_id;
				if (event.getBoolean("opened")) {
					main_text = "Door Opened";
					sub_text += " was opened.";
				} else {
					main_text = "Door Closed";
					sub_text += " was closed.";
				}

				break;
			}
			case WINDOW_SENSOR_EVENT: {
				int window_id = event.getInt("window_id");

				sub_text = "Window " + window_id;
				if (event.getBoolean("opened")) {
					main_text = "Window Opened";
					sub_text += " was opened.";
				} else {
					main_text = "Window Closed";
					sub_text += " was closed.";
				}

				break;
			}
			case FLOOD_SENSOR_EVENT:
				main_text = "Flood Sensor Reading";

				int water_level = event.getInt("water_height");
				sub_text = "Water level is " + water_level + "cm.";

				break;
			case TEMP_SENSOR_EVENT:
				main_text = "Temperature Reading";

				int temperature = event.getInt("temperature");
				sub_text = "Temperature is " + temperature + " degrees.";

				break;
			case ALARM_EVENT: {
				int severity = event.getInt("severity");
				if (severity == CRITICAL_ALARM) {
					main_text = "Critical Alarm";
				} else if (severity == MAJOR_ALARM) {
					main_text = "Major Alarm";
				} else if (severity == MINOR_ALARM) {
					main_text = "Minor Alarm";
				} else {
					main_text = "Alarm";
				}

				sub_text = event.getString("description");
				event_map.put("image_resource", R.drawable.alarm);

				break;
			}
			case KEYPAD_EVENT:
				main_text = "Keypad Event";
				sub_text = "Key '" + event.getString("input_char") + "' was pressed.";

				break;
			case NFC_EVENT:
				main_text = "NFC Event";

				break;
			case MOTION_SENSOR_EVENT:
				main_text = "Motion Sensor Event";
				sub_text = "Motion over 30 seconds detected.";

				break;
			default:
				main_text = "Unknown Event";
				break;
			}

			event_map.put("main_text", main_text);
			event_map.put("sub_text", sub_text);
			event_list.add(event_map);
		}

		Collections.reverse(event_list);
		return event_list;
	}

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.main);
	}

	@Override
	protected void onStart() {
		super.onStart();

		refreshData();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater;

		inflater = getMenuInflater();
		inflater.inflate(R.menu.main, menu);

		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		Intent intent;

		switch (item.getItemId()) {
		case R.id.settings_item:
			intent = new Intent(getBaseContext(), PreferencesActivity.class);
			startActivity(intent);
			return true;
		case R.id.refresh_item:
			refreshData();
			return true;
		default:
			return super.onOptionsItemSelected(item);
		}
	}

}